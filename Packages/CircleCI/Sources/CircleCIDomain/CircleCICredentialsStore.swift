public protocol CircleCICredentialsStore: AnyObject {
    var resourceClassToken: String? { get }

    func setResourceClassToken(_ authToken: String?)
}
