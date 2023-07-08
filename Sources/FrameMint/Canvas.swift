import CoreGraphics
import SwiftUI
import UIKit

/// Canvas to draw UIView/SwiftUI contents.
public final class Canvas {
    /// Width of canvas.
    public let width: Int
    /// Height of canvas.
    public let height: Int
    /// Extent of canvas.
    public let extent: UIEdgeInsets
    ///  Pixel buffer (kCVPixelFormatType_32ARGB) to draw contents.
    nonisolated public let pixelBuffer: CVPixelBuffer
    /// Context to draw into pixel buffer.
    public let context: CGContext

    /// Content view for drawn contents on pixel buffer.
    public let content: UIView
    /// Rect of content view.
    public let contentRect: CGRect

    /// Renderer to draw view contents as image.
    private let renderer: UIGraphicsImageRenderer

    init(width: Int, height: Int, extent: UIEdgeInsets, pixelBuffer: CVPixelBuffer) throws {
        self.width = width
        self.height = height
        self.extent = extent
        self.pixelBuffer = pixelBuffer

        self.contentRect = CGRect(origin: .zero, size: .init(width: width, height: height))
        self.content = UIView(frame: contentRect)

        self.renderer = UIGraphicsImageRenderer(size: contentRect.size)

        guard CVPixelBufferLockBaseAddress(pixelBuffer, .readOnly) == kCVReturnSuccess else {
            throw FrameMintError.failedToLockPixelBufferBaseAddress
        }
        defer {
            CVPixelBufferUnlockBaseAddress(pixelBuffer, .readOnly)
        }

        guard let context = CGContext(
            data: CVPixelBufferGetBaseAddress(pixelBuffer),
            width: CVPixelBufferGetWidth(pixelBuffer),
            height: CVPixelBufferGetHeight(pixelBuffer),
            bitsPerComponent: 8,
            bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer),
            space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue
        ) else {
            throw FrameMintError.faieldToGetContextToDrawContents
        }
        self.context = context
    }

    /// Clear all contents on canvas.
    public func clearContents() {
        content.subviews.forEach { subview in
            subview.removeFromSuperview()
        }
    }

    /// Draw contents on content view into pixel buffer.
    public func drawContents() {
        let image = renderer.image { context in
            content.drawHierarchy(in: contentRect, afterScreenUpdates: true)
        }
        guard let cgImage = image.cgImage else {
            return
        }
        context.draw(cgImage, in: contentRect, byTiling: false)
    }

    /// Draw image into pixel buffer in whole rect of content.
    ///
    /// - parameters:
    ///   - image: Image to draw.
    public func drawImage(_ image: UIImage) {
        guard let cgImage = image.cgImage else {
            return
        }
        context.draw(cgImage, in: contentRect, byTiling: false)
    }

    /// Add SwiftUI contents over current contents.
    ///
    /// - parameters:
    ///   - builder: Builder to make SwiftUI contents.
    @MainActor
    public func addSwiftUIContents(_ builder: () -> some View) {
        let hostingController = UIHostingController(rootView: builder())
        hostingController.view.frame = content.bounds
        hostingController.view.backgroundColor = .clear
        hostingController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        content.addSubview(hostingController.view)
        content.setNeedsLayout()
        content.layoutIfNeeded()
        content.setNeedsDisplay()
    }
}

extension Canvas {
    /// Make 420YpCbCr8BiPlanarFullRange format pixel buffer from this instance.
    ///
    /// - parameters:
    ///   - pixelBufferFactory: PixelBufferFactory to make CVPixelBuffer.
    public func make420YpCbCr8BiPlanarFullRangePixelBuffer(pixelBufferFactory: PixelBufferFactory = .default) throws -> CVPixelBuffer {
        try pixelBufferFactory.make420YpCbCr8BiPlanarFullRangePixelBuffer(from: self)
    }
}
