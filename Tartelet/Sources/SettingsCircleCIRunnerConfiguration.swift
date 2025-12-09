import SettingsDomain
import VirtualMachineDomain

struct SettingsCircleCIRunnerConfiguration<
    SettingsStoreType: SettingsStore
>: CircleCIRunnerConfiguration {
    let settingsStore: SettingsStoreType

    var runnerName: String {
        settingsStore.circleCIRunnerName
    }
}
