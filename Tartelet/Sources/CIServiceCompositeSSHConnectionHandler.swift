import SettingsDomain
import SSHDomain
import VirtualMachineDomain

struct CIServiceCompositeSSHConnectionHandler<SettingsStoreType: SettingsStore>: VirtualMachineSSHConnectionHandler {
    let settings: SettingsStoreType
    let gitHubConnectionHandler: GitHubActionsRunnerSSHConnectionHandler
    let circleCIConnectionHandler: CircleCIRunnerSSHConnectionHandler

    func didConnect(
        to virtualMachine: any VirtualMachineDomain.VirtualMachine,
        through connection: any SSHDomain.SSHConnection
    ) async throws {
        switch settings.ciService {
        case .github:
            try await gitHubConnectionHandler.didConnect(to: virtualMachine, through: connection)
        case .circleci:
            try await circleCIConnectionHandler.didConnect(to: virtualMachine, through: connection)
        }
    }
}
