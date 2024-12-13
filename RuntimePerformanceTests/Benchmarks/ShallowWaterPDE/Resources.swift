import Foundation

enum Resources {
    case swiftLogo

    var url: URL {
        switch self {
            case .swiftLogo: return Bundle.module
            .url(forResource: "target", withExtension: "png")! // swiftlint:disable:this force_unwrapping
        }
    }
}
