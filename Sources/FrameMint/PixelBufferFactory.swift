import Accelerate
import CoreMedia
import UIKit

/// Factory of CVPixelBuffer.
public final class PixelBufferFactory {
    /// Default instance
    public static let `default` = PixelBufferFactory()

    /// Pixel format for CVPixelBuffer.
    public enum PixelFormatType: String {
        /// kCVPixelFormatType_32ARGB
        case _32ARGB
        /// kCVPixelFormatType_420YpCbCr8BiPlanarFullRange
        case _420YpCbCr8BiPlanarFullRange

        public var key: OSType {
            switch self {
            case ._32ARGB:
                return kCVPixelFormatType_32ARGB
            case ._420YpCbCr8BiPlanarFullRange:
                return kCVPixelFormatType_420YpCbCr8BiPlanarFullRange
            }
        }
    }

    /// Stored pixel buffer pools corresponds to pixel buffer size.
    private var pixelBufferPoolDictionary: [String: CVPixelBufferPool] = [:]

    /// Return new pixel buffer.
    ///
    /// - parameters:
    ///   - width: Width of pixel buffer.
    ///   - height: Height of pixel buffer.
    ///   - extent: Extent of pixel buffer.
    ///   - pixelFormatType: PixelFormatType of pixel buffer.
    /// - returns:
    ///   - New pixel buffer.
    public func makePixelBuffer(width: Int, height: Int, extent: UIEdgeInsets, pixelFormatType: PixelFormatType) throws -> CVPixelBuffer {
        let pixelBufferPoolKey = makePixelBufferPoolDictionaryKey(
            width: width,
            height: height,
            extent: extent,
            pixelFormatType: pixelFormatType
        )
        if pixelBufferPoolDictionary[pixelBufferPoolKey] == nil {
            pixelBufferPoolDictionary[pixelBufferPoolKey] = makePixelBufferPool(
                width: width,
                height: height,
                extent: extent,
                pixelFormatType: pixelFormatType
            )
        }
        guard let pixelBufferPool = pixelBufferPoolDictionary[pixelBufferPoolKey] else {
            throw FrameMintError.failedToCreatePixelbuffer
        }

        var pixelBufferOut: CVPixelBuffer?
        CVPixelBufferPoolCreatePixelBuffer(nil, pixelBufferPool, &pixelBufferOut)
        guard let pixelBufferOut = pixelBufferOut else {
            throw FrameMintError.failedToCreatePixelbuffer
        }
        return pixelBufferOut
    }

    /// Clear all stored pixel buffer pools.
    public func clearStoredPools() {
        pixelBufferPoolDictionary = [:]
    }

    /// Make key to get stored pixel buffer pool.
    ///
    /// - parameters:
    ///   - width: Width of pixel buffer.
    ///   - height: Height of pixel buffer.
    ///   - extent: Extent of pooled pixel buffer.
    /// - returns:
    ///   Key to get stored pixel buffer pool.
    private func makePixelBufferPoolDictionaryKey(width: Int, height: Int, extent: UIEdgeInsets, pixelFormatType: PixelFormatType) -> String {
        "\(width),\(height):\(extent.top),\(extent.left),\(extent.bottom),\(extent.right),\(pixelFormatType.key)"
    }

    /// Create CVPixelBufferPool for given parameters.
    ///
    /// - parameters:
    ///   - width: Width of pooled pixel buffer.
    ///   - height: Height of pooled pixel buffer.
    ///   - extent: Extent of pooled pixel buffer.
    /// - returns:
    ///   Created CVPixelBufferPool.
    private func makePixelBufferPool(width: Int, height: Int, extent: UIEdgeInsets, pixelFormatType: PixelFormatType) -> CVPixelBufferPool? {
        var attributes = [
            kCVPixelBufferWidthKey: width,
            kCVPixelBufferHeightKey: height,
            kCVPixelBufferExtendedPixelsTopKey: Int(extent.top),
            kCVPixelBufferExtendedPixelsRightKey: Int(extent.right),
            kCVPixelBufferExtendedPixelsBottomKey: Int(extent.bottom),
            kCVPixelBufferExtendedPixelsLeftKey: Int(extent.left),
            kCVPixelBufferPixelFormatTypeKey: pixelFormatType.key,
            kCVPixelBufferIOSurfacePropertiesKey: [:] as CFDictionary,
            kCVPixelBufferPoolAllocationThresholdKey: Int(1)
        ] as [String: Any]
        switch pixelFormatType {
        case ._32ARGB:
            attributes[kCVPixelBufferCGImageCompatibilityKey as String] = kCFBooleanTrue!
            attributes[kCVPixelBufferCGBitmapContextCompatibilityKey as String] = kCFBooleanTrue!
        case ._420YpCbCr8BiPlanarFullRange:
            break
        }
        var pixelBufferPool: CVPixelBufferPool?
        CVPixelBufferPoolCreate(nil, nil, attributes as CFDictionary, &pixelBufferPool)
        return pixelBufferPool
    }

    /// Make 420YpCbCr8BiPlanarFullRange format pixel buffer from Canvas instance.
    ///
    /// - parameters:
    ///   - from canvas: Canvas as source of output pixel buffer.
    public func make420YpCbCr8BiPlanarFullRangePixelBuffer(from canvas: Canvas) throws -> CVPixelBuffer {
        var info: vImage_ARGBToYpCbCr = vImage_ARGBToYpCbCr()
        var pixelRange = vImage_YpCbCrPixelRange(Yp_bias: 0, CbCr_bias: 128, YpRangeMax: 255, CbCrRangeMax: 255, YpMax: 255, YpMin: 1, CbCrMax: 255, CbCrMin: 0)
        vImageConvert_ARGBToYpCbCr_GenerateConversion(kvImage_ARGBToYpCbCrMatrix_ITU_R_709_2, &pixelRange, &info, kvImageARGB8888, kvImage420Yp8_CbCr8, 0)

        let width = vImagePixelCount(canvas.width)
        let height = vImagePixelCount(canvas.height)

        let dest = try makePixelBuffer(
            width: Int(width),
            height: Int(height),
            extent: canvas.extent,
            pixelFormatType: ._420YpCbCr8BiPlanarFullRange
        )

        defer {
            CVPixelBufferUnlockBaseAddress(canvas.pixelBuffer, .readOnly)
            CVPixelBufferUnlockBaseAddress(dest, .readOnly)
        }
        guard CVPixelBufferLockBaseAddress(canvas.pixelBuffer, .readOnly) == kCVReturnSuccess,
              CVPixelBufferLockBaseAddress(dest, .readOnly) == kCVReturnSuccess else {
            throw FrameMintError.failedToLockPixelBufferBaseAddress
        }

        // src
        let dataSrc = CVPixelBufferGetBaseAddress(canvas.pixelBuffer)
        let rowBytesSrc = CVPixelBufferGetBytesPerRow(canvas.pixelBuffer)
        var src = vImage_Buffer(data: dataSrc, height: height, width: width, rowBytes: rowBytesSrc)

        // dest Yp
        let rowBytesDestYp = CVPixelBufferGetBytesPerRowOfPlane(dest, 0)
        let dataDestYp = CVPixelBufferGetBaseAddressOfPlane(dest, 0)
        var destYp = vImage_Buffer(data: dataDestYp, height: height, width: width, rowBytes: rowBytesDestYp)

        // dest CbCr
        let rowBytesDestCbCr = CVPixelBufferGetBytesPerRowOfPlane(dest, 1)
        let dataDestCbCr = CVPixelBufferGetBaseAddressOfPlane(dest, 1)
        var destCbCr = vImage_Buffer(data: dataDestCbCr, height: height, width: width, rowBytes: rowBytesDestCbCr)

        var permuteMap: [UInt8] = [0, 1, 2, 3]
        vImageConvert_ARGB8888To420Yp8_CbCr8(&src, &destYp, &destCbCr, &info, &permuteMap, vImage_Flags(kvImageDoNotTile))

        return dest
    }
}
