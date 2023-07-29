import CoreMedia
import XCTest
@testable import FrameMint

final class SampleBufferFactoryTests: XCTestCase {
    func testCreateSampleBuffers() {
        let pixelBufferFactory = PixelBufferFactory.default
        let sampleBufferFactory = SampleBufferFactory.default

        XCTContext.runActivity(named: "Create 32ARGB 100x100") { _ in
            let _pixelBuffer = try! pixelBufferFactory.makePixelBuffer(
                width: 100,
                height: 100,
                extent: .zero,
                pixelFormatType: ._32ARGB
            )
            let sampleBuffer = sampleBufferFactory.make420YpCbCr8BiPlanarFullRangeSampleBuffer(from: _pixelBuffer, orientation: 1)
            let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)!
            XCTAssert(CVPixelBufferGetWidth(pixelBuffer) == 100)
            XCTAssert(CVPixelBufferGetHeight(pixelBuffer) == 100)
            XCTAssert(CVPixelBufferGetPixelFormatType(pixelBuffer) == kCVPixelFormatType_32ARGB)
        }
    }
}
