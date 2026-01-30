import Foundation

public protocol VirtualMachine {
    var name: String { get }
    var canStart: Bool { get }
    func start() async throws
    func clone(named newName: String) async throws -> VirtualMachine
    func delete() async throws
    func getIPAddress() async throws -> String
}

extension VirtualMachine {
    func runnerName(preferring preferredName: String) -> String {
        // If no custom runner name is configured, use the VM name as-is
        if preferredName.isEmpty {
            return name
        }

        // Extract the index suffix from VM names like "baseVM-1", "baseVM-2"
        if let lastDashIndex = name.lastIndex(of: "-") {
            let indexString = String(name[name.index(after: lastDashIndex)...])
            if !indexString.isEmpty, Int(indexString) != nil {
                return "\(preferredName) \(indexString)"
            }
        }
        // Fallback to just the runner name if we can't extract an index
        return preferredName
    }
}
