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
            case .helloWorld:
                canvas.addSwiftUIContents { makeHelloWorldView() }
            case .notification(let property):
                canvas.addSwiftUIContents { makeNotificationView(property) }
            }
            canvas.drawContents()
            return try canvas.make420YpCbCr8BiPlanarFullRangePixelBuffer()
        } catch {
            fatalError(error.localizedDescription)
        }
    }

    private func makeHelloWorldView() -> some View {
        ZStack(alignment: .center) {
            EmptyView()
                .background(.white)
            Text("Hello, world!")
                .font(.system(size: 40, weight: .medium))
        }
    }

    private func makeNotificationView(_ property: NotificationProperty) -> some View {
        VStack {
            HStack(alignment: .center, spacing: 34) {
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
                RoundedRectangle(cornerRadius: property.notificationCornerRadius, style: .continuous)
                    .fill(Color.white)
                    .shadow(color: Color(white: 0, opacity: 0.1), radius: 16)
            }
            .overlay(alignment: .topTrailing) {
                Text(property.time)
                    .font(property.timeFont)
                    .foregroundStyle(.black.opacity(0.3))
                    .padding(EdgeInsets(top: 40, leading: 0, bottom: 0, trailing: 42))
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
    
    func makeImage(from pixelBuffer: CVPixelBuffer, _ ciContext: CIContext = CIContext()) -> UIImage? {
        let ciImage = CIImage(cvImageBuffer: pixelBuffer)
        guard let cgImage = ciContext.createCGImage(ciImage, from: ciImage.extent) else {
            return nil
        }
        return UIImage(cgImage: cgImage)
    }
}
