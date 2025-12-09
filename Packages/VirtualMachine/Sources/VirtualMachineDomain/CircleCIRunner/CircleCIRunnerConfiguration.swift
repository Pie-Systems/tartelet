public protocol CircleCIRunnerConfiguration {
    var runnerName: String { get }
    var useHomeSSHDirectoryForCheckoutKeys: Bool { get }
}
