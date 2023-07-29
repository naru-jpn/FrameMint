import CoreMedia
import ReplayKit

/// Factory of CMSampleBuffer.
public final class SampleBufferFactory {
    /// Default instance
    public static let `default` = SampleBufferFactory()

    /// Make 420YpCbCr8BiPlanarFullRange format sample buffer from Canvas instance.
    ///
    /// - parameters:
    ///   - from imageBuffer: CVPixelBuffer instance contained CMSampleBuffer.
    ///   - orientation: A value about frame orientation related with RPVideoSampleOrientationKey.
    public func make420YpCbCr8BiPlanarFullRangeSampleBuffer(from imageBuffer: CVPixelBuffer, orientation: Int) -> CMSampleBuffer {
        var sampleTiming = CMSampleTimingInfo.invalid
        var formatDescription: CMFormatDescription!
        CMVideoFormatDescriptionCreateForImageBuffer(allocator: kCFAllocatorDefault, imageBuffer: imageBuffer, formatDescriptionOut: &formatDescription)
        var sampleBuffer: CMSampleBuffer!
        CMSampleBufferCreateForImageBuffer(
            allocator: kCFAllocatorDefault,
            imageBuffer: imageBuffer,
            dataReady: true,
            makeDataReadyCallback: nil,
            refcon: nil,
            formatDescription: formatDescription,
            sampleTiming: &sampleTiming,
            sampleBufferOut: &sampleBuffer
        )
        let orientationKey = RPVideoSampleOrientationKey as CFString
        let orientationValue = orientation as NSNumber
        CMSetAttachment(sampleBuffer, key: orientationKey, value: orientationValue, attachmentMode: kCMAttachmentMode_ShouldNotPropagate)
        return sampleBuffer
    }
}
