public enum CIService: String, CaseIterable, Identifiable {
    case github
    case circleci

    public var id: Self { self }
}
