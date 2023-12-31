import CoreImage
import FrameMint
import SwiftUI

@MainActor
class FrameMaker {
    static let shared = FrameMaker()

    func makeFrame(_ content: FrameContent) -> CVPixelBuffer  {
        do {
            let canvas = try FrameMint.CanvasFactory().makeCanvas(width: content.width, height: content.height, extent: .zero)
            canvas.content.backgroundColor = .white
            switch content {
            case .helloWorld(_, let type):
                switch type {
                case .swiftui:
                    canvas.addSwiftUIContents {
                        makeHelloWorldView()
                    }
                    canvas.drawContents()
                case .uikit:
                    addHelloWorldLabel(on: canvas.content)
                    canvas.drawContents()
                }
            case .notification(_, let property):
                canvas.addSwiftUIContents {
                    makeNotificationView(property)
                }
                canvas.drawContents()
            case .resource(_, let property):
                canvas.drawImage(UIImage(resource: property.resource))
            }
            return try canvas.make420YpCbCr8BiPlanarFullRangePixelBuffer()
        } catch {
            fatalError(error.localizedDescription)
        }
    }

    private func makeHelloWorldView() -> some View {
        ZStack(alignment: .center) {
            Color.white
            Text("Hello, world!")
                .font(.system(size: 40, weight: .medium))
        }
    }

    private func addHelloWorldLabel(on view: UIView) {
        let label = UILabel(frame: view.bounds)
        label.backgroundColor = .white
        label.text = "Hello, world!"
        label.font = .systemFont(ofSize: 40, weight: .medium)
        label.textAlignment = .center
        view.addSubview(label)
    }

    private func makeNotificationView(_ property: NotificationProperty) -> some View {
        GeometryReader { geometry in
            ZStack {
                if let resource = property.backgroundImageResource {
                    Image(resource)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .edgesIgnoringSafeArea(.all)
                } else {
                    Color.white.frame(width: geometry.size.width, height: geometry.size.height)
                }
                VStack {
                    HStack(alignment: .center, spacing: property.contentSpacing) {
                        Image(property.iconImageResource)
                            .resizable()
                            .frame(width: property.iconWidth, height: property.iconWidth)
                            .clipShape(RoundedRectangle(cornerRadius: property.iconCornerRadius, style: .continuous))
                        VStack(spacing: 0) {
                            Text(property.title)
                                .font(property.titleFont)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Text(property.body)
                                .font(property.bodyFont)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .lineLimit(2)
                        }
                    }
                    .padding(property.notificationPadding)
                    .background {
                        Color.clear
                            .background(VisualEffect(style: .systemMaterial))
                            .clipShape(
                                RoundedRectangle(cornerRadius: property.notificationCornerRadius, style: .continuous)
                            )
                            .shadow(color: Color(white: 0, opacity: 0.15), radius: property.notificationCornerRadius)
                    }
                    .overlay(alignment: .topTrailing) {
                        Text(property.time)
                            .font(property.timeFont)
                            .foregroundStyle(.black.opacity(0.5))
                            .padding(EdgeInsets(top: property.timeMarginTop, leading: 0, bottom: 0, trailing: property.timeMarginTrailing))
                    }
                    Spacer()
                }
                .padding(
                    EdgeInsets(
                        top: property.notificationMarginTop,
                        leading: property.notificationMarginLeading,
                        bottom: 0,
                        trailing: property.notificationMarginLeading
                    )
                )
                .ignoresSafeArea(edges: [.top])
            }
        }
        .ignoresSafeArea(.all)
    }

    func makeImage(from pixelBuffer: CVPixelBuffer, _ ciContext: CIContext = CIContext()) -> UIImage? {
        let ciImage = CIImage(cvImageBuffer: pixelBuffer)
        guard let cgImage = ciContext.createCGImage(ciImage, from: ciImage.extent) else {
            return nil
        }
        return UIImage(cgImage: cgImage)
    }
}

// Reference: https://www.swiftanytime.com/blog/add-visual-effects-blur-in-swiftui
private struct VisualEffect: UIViewRepresentable {
    @State var style : UIBlurEffect.Style
    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: style))
    }
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
    }
}
