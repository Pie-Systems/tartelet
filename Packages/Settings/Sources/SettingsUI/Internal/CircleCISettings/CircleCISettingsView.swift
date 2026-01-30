import CircleCIDomain
import SettingsDomain
import SwiftUI

struct CircleCISettingsView<SettingsStoreType: SettingsStore & Observable>: View {
    @Bindable var settingsStore: SettingsStoreType
    let credentialsStore: CircleCICredentialsStore

    @State private var resourceClassToken: String = ""

    var body: some View {
        Form {
            SecureField(
                L10n.Settings.Circleci.resourceClassToken,
                text: $resourceClassToken,
                prompt: Text(L10n.Settings.Circleci.ResourceClassToken.prompt)
            )
        }
        .formStyle(.grouped)
        .onChange(of: resourceClassToken) { _, newValue in
            if !newValue.isEmpty {
                credentialsStore.setResourceClassToken(newValue)
            } else {
                credentialsStore.setResourceClassToken(nil)
            }
        }
    }

    init(settingsStore: SettingsStoreType, credentialsStore: CircleCICredentialsStore) {
        self.settingsStore = settingsStore
        self.credentialsStore = credentialsStore
        self.resourceClassToken = credentialsStore.resourceClassToken ?? ""
    }
}
