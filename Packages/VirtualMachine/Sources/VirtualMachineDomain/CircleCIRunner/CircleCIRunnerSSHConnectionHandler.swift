import CircleCIDomain
import Foundation
import LoggingDomain
import SSHDomain

private enum CircleCIRunnerSSHConnectionHandlerError: LocalizedError {
    case resourceClassTokenUnavailable

    var errorDescription: String? {
        switch self {
        case .resourceClassTokenUnavailable:
            return "The Resource Class Token is unavailable"
        }
    }
}

public struct CircleCIRunnerSSHConnectionHandler: VirtualMachineSSHConnectionHandler {
    private let logger: Logger
    private let credentialsStore: CircleCICredentialsStore
    private let configuration: CircleCIRunnerConfiguration

    public init(
        logger: Logger,
        credentialsStore: CircleCICredentialsStore,
        configuration: CircleCIRunnerConfiguration
    ) {
        self.logger = logger
        self.credentialsStore = credentialsStore
        self.configuration = configuration
    }

    public func didConnect(
        to virtualMachine: any VirtualMachine,
        through connection: any SSHDomain.SSHConnection
    ) async throws {
        guard let authToken = credentialsStore.resourceClassToken else {
            logger.error("Resource Class Token is not available")
            throw CircleCIRunnerSSHConnectionHandlerError.resourceClassTokenUnavailable
        }

        let name = virtualMachine.runnerName(preferring: configuration.runnerName)
        logger.info("Starting with name \"\(name)\"")

        let startRunnerScriptFilePath = "~/start-runner.sh"
        try await connection.executeCommand("touch \(startRunnerScriptFilePath)")
        try await connection.executeCommand("""
cat > \(startRunnerScriptFilePath) << EOF
#!/bin/zsh

# Ensure the virtual machine is restarted when a job is done.
set -e pipefail
function onexit {
  sudo shutdown -h now
}
trap onexit EXIT

# Wait until we can connect to CircleCI.
until curl -Is https://circleci.com &>/dev/null; do :; done

# Download the runner.
brew tap circleci-public/circleci
brew install circleci-runner

# Review and accept the Apple signature notarization
spctl -a -vvv -t install "\\$(brew --prefix)/bin/circleci-runner"
sudo xattr -r -d com.apple.quarantine "\\$(brew --prefix)/bin/circleci-runner"

# Configure pre-run script.
PRE_RUN_SCRIPT_PATH="\\$HOME/.tartelet/pre-run.sh"

# Configure post-run script.
POST_RUN_SCRIPT_PATH="\\$HOME/.tartelet/post-run.sh"

circleci-runner machine --api.auth-token="\(authToken)" \
  --runner.name="\(name)" \
  --runner.mode="single-task" \
  --runner.working-directory="\\$HOME/project" \
  --runner.cleanup-working-directory="false"

EOF
""")
        try await connection.executeCommand("chmod +x \(startRunnerScriptFilePath)")
        try await connection.executeCommand("open -a Terminal \(startRunnerScriptFilePath)")
    }
}
