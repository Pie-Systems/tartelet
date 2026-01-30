import LoggingDomain
import Observation
import SettingsDomain
import SwiftUI

struct GeneralSettingsView<SettingsStoreType: SettingsStore & Observable>: View {
    @Bindable var settingsStore: SettingsStoreType
    let logExporter: LogExporter

    var body: some View {
        Form {
            Picker(
                L10n.Settings.General.applicationUiMode,
                selection: $settingsStore.applicationUIMode
            ) {
                ForEach(ApplicationUIMode.allCases) { mode in
                    Text(mode.title)
                }
            }

            Picker(L10n.Settings.General.ciService, selection: $settingsStore.ciService) {
                ForEach(CIService.allCases) { service in
                    Text(service.title)
                }
            }
        }
        .formStyle(.grouped)
        .overlay(alignment: .bottomTrailing) {
            Button {
                logExporter.export()
            } label: {
                Text(L10n.Settings.General.exportLogs)
            }
        }
        .padding()
    }
}
