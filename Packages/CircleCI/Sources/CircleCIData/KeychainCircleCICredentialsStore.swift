import CircleCIDomain
import Keychain
import Observation

@Observable
public final class KeychainCircleCICredentialsStore: CircleCICredentialsStore {
    private enum PasswordAccount {
        static let resourceClassToken = "circleci.credentials.resourceClassToken"
    }

    private let keychain: Keychain
    private let serviceName: String

    public var resourceClassToken: String? {
        access(keyPath: \.resourceClassToken)
        return keychain.password(
            forAccount: PasswordAccount.resourceClassToken,
            belongingToService: serviceName
        )
    }

    public init(keychain: Keychain, serviceName: String) {
        self.keychain = keychain
        self.serviceName = serviceName
    }

    public func setResourceClassToken(_ authToken: String?) {
        withMutation(keyPath: \.resourceClassToken) {
            if let authToken {
                _ = keychain.setPassword(
                    authToken,
                    forAccount: PasswordAccount.resourceClassToken,
                    belongingToService: serviceName
                )
            } else {
                keychain.removePassword(
                    forAccount: PasswordAccount.resourceClassToken,
                    belongingToService: serviceName
                )
            }
        }
    }
}
