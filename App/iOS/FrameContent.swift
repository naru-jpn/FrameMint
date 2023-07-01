import SwiftUI

enum FrameContent: Identifiable {
    case helloWorld
    case notification(property: NotificationProperty)

    var id: String {
        title + String(width) + String(height)
    }

    var title: String {
        switch self {
        case .helloWorld:
            return "Hello, world!"
        case .notification(let property):
            switch property {
            case .iPhone14:
                return "Push Notification (iPhone14)"
            default:
                return "-"
            }
        }
    }

    var width: Int {
        switch self {
        case .helloWorld:
            return 1024
        case .notification(let property):
            return property.width
        }
    }

    var height: Int {
        switch self {
        case .helloWorld:
            return 1024
        case .notification(let property):
            return property.height
        }
    }
}

struct NotificationProperty: Equatable {
    let width: Int
    let height: Int
    let iconWidth: CGFloat
    let iconCornerRadius: CGFloat
    let notificationMarginTop: CGFloat
    let notificationMarginLeading: CGFloat
    let notificationCornerRadius: CGFloat
    let notificationPadding: EdgeInsets
    let contentSpacing: Int
    let title: String
    let titleFont: Font
    let body: String
    let bodyFont: Font
    let time: String
    let timeFont: Font
    let iconImageResource: ImageResource

    private static let sampleTitle = "Rendered Push Notification"
    private static let sampleBody = "あのイーハトーヴォのすきとおった風、夏でも底に冷たさをもつ青いそら、うつくしい森で飾られたモリーオ市、郊外のぎらぎらひかる草の波"
    private static let sampleTimeNow = "今"

    static var iPhone14: NotificationProperty {
        .init(
            width: 1170,
            height: 2532,
            iconWidth: 112,
            iconCornerRadius: 26,
            notificationMarginTop: 122,
            notificationMarginLeading: 24,
            notificationCornerRadius: 68,
            notificationPadding: .init(top: 40, leading: 42, bottom: 40, trailing: 86),
            contentSpacing: 34,
            title: sampleTitle,
            titleFont: .system(size: 48, weight: .medium),
            body: sampleBody,
            bodyFont: .system(size: 44, weight: .regular),
            time: sampleTimeNow,
            timeFont: .system(size: 38, weight: .regular),
            iconImageResource: ImageResource(name: "default_icon", bundle: .main)
        )
    }
}
