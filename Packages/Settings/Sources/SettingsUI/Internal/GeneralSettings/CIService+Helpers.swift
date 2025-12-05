import SettingsDomain
import SwiftUI

extension CIService {
    var title: String {
        switch self {
        case .github:
            L10n.Settings.github
        case .circleci:
            L10n.Settings.circleci
        }
    }

    var image: Image {
        switch self {
        case .github:
            Asset.github.swiftUIImage
        case .circleci:
            Asset.circleci.swiftUIImage
        }
    }
}
