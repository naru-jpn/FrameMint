import SwiftUI

enum FrameContent: Identifiable {
    case helloWorld(title: String)
    case notification(title: String, property: NotificationProperty)
    case resource(title: String, property: ResourceProperty)

    var id: String {
        title + String(width) + String(height)
    }

    var title: String {
        switch self {
        case .helloWorld(let title):
            return title
        case .notification(let title, _):
            return title
        case .resource(let title, _):
            return title
        }
    }

    var width: Int {
        switch self {
        case .helloWorld:
            return 1024
        case .notification(_, let property):
            return property.width
        case .resource(_, let property):
            return property.width
        }
    }

    var height: Int {
        switch self {
        case .helloWorld:
            return 1024
        case .notification(_, let property):
            return property.height
        case .resource(_, let property):
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
    let timeMarginTop: CGFloat
    let timeMarginTrailing: CGFloat
    let contentSpacing: Int
    let title: String
    let titleFont: Font
    let body: String
    let bodyFont: Font
    let time: String
    let timeFont: Font
    let iconImageResource: ImageResource
    let backgroundImageResource: ImageResource?

    static func iPhone14(title: String, body: String, time: String, icon: ImageResource, background: ImageResource?) -> NotificationProperty {
        .init(
            width: 1170,
            height: 2532,
            iconWidth: 112,
            iconCornerRadius: 26,
            notificationMarginTop: 122,
            notificationMarginLeading: 24,
            notificationCornerRadius: 68,
            notificationPadding: .init(top: 40, leading: 42, bottom: 40, trailing: 86),
            timeMarginTop: 40,
            timeMarginTrailing: 46,
            contentSpacing: 34,
            title: title,
            titleFont: .system(size: 48, weight: .medium),
            body: body,
            bodyFont: .system(size: 44, weight: .regular),
            time: time,
            timeFont: .system(size: 38, weight: .regular),
            iconImageResource: icon,
            backgroundImageResource: background
        )
    }

    static func iPadMini6(title: String, body: String, time: String, icon: ImageResource, background: ImageResource?) -> NotificationProperty {
        .init(
            width: 1488,
            height: 2266,
            iconWidth: 74,
            iconCornerRadius: 16,
            notificationMarginTop: 16,
            notificationMarginLeading: 188,
            notificationCornerRadius: 44,
            notificationPadding: .init(top: 22, leading: 24, bottom: 26, trailing: 78),
            timeMarginTop: 22,
            timeMarginTrailing: 32,
            contentSpacing: 18,
            title: title,
            titleFont: .system(size: 32, weight: .medium),
            body: body,
            bodyFont: .system(size: 30, weight: .regular),
            time: time,
            timeFont: .system(size: 26, weight: .regular),
            iconImageResource: icon,
            backgroundImageResource: background
        )
    }
}

struct ResourceProperty {
    let width: Int
    let height: Int
    let resource: ImageResource
}
