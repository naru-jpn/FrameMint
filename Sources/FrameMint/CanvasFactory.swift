import Foundation
import CoreMedia
import UIKit

/// Create YCbCr420 format pixel buffer.
public final class CanvasFactory {

    public init() {}

    /// Make pixel buffer for given parameters using preferred pixel buffer pool.
    ///
    /// - parameters:
    ///   - width: Width of canvas.
    ///   - height: Height of canvas.
    ///   - extent: Extent(padding for pixel buffer) of canvas.
    /// - returns:
    ///   Created CVPixelBuffer.
    @MainActor
    public func makeCanvas(
        width: Int,
        height: Int,
        extent: UIEdgeInsets,
        pixelBufferFactory: PixelBufferFactory = .default
    ) throws -> Canvas {
        let pixelBuffer = try pixelBufferFactory.makePixelBuffer(
            width: width,
            height: height,
            extent: extent,
            pixelFormatType: ._32ARGB
        )
        return try Canvas(
            width: width,
            height: height,
            extent: extent,
            pixelBuffer: pixelBuffer
        )
    }
}
