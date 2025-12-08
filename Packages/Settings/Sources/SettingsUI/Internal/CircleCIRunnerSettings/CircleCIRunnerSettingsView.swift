import CircleCIDomain
import SettingsDomain
import SwiftUI

struct CircleCIRunnerSettingsView<SettingsStoreType: SettingsStore & Observable>: View {
    @Bindable var settingsStore: SettingsStoreType
    let isSettingsEnabled: Bool

    var runnerNamePrompt: String {
        switch settingsStore.virtualMachine {
        case .unknown:
            return L10n.Settings.Runner.Name.prompt
        case .virtualMachine(let name):
            return name
        }
    }

    var body: some View {
        Form {
            Section {
                TextField(
                    L10n.Settings.Runner.name,
                    text: $settingsStore.circleCIRunnerName,
                    prompt: Text(runnerNamePrompt)
                )
                .disabled(!isSettingsEnabled)
            }
        }
        .formStyle(.grouped)
    }
}
