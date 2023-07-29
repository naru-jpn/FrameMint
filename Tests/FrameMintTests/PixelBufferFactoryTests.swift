import XCTest
@testable import FrameMint

final class PixelBufferFactoryTests: XCTestCase {
    func testCreatePixelBuffers() {
        let factory = PixelBufferFactory.default

        XCTContext.runActivity(named: "Create 32ARGB 100x100") { _ in
            let pixelBuffer = try! factory.makePixelBuffer(
                width: 100,
                height: 100,
                extent: .zero,
                pixelFormatType: ._32ARGB
            )
            XCTAssert(CVPixelBufferGetWidth(pixelBuffer) == 100)
            XCTAssert(CVPixelBufferGetHeight(pixelBuffer) == 100)
            XCTAssert(CVPixelBufferGetPixelFormatType(pixelBuffer) == kCVPixelFormatType_32ARGB)
        }

        XCTContext.runActivity(named: "Create 32ARGB 100x150") { _ in
            let pixelBuffer = try! factory.makePixelBuffer(
                width: 100,
                height: 150,
                extent: .zero,
                pixelFormatType: ._32ARGB
            )
            XCTAssert(CVPixelBufferGetWidth(pixelBuffer) == 100)
            XCTAssert(CVPixelBufferGetHeight(pixelBuffer) == 150)
            XCTAssert(CVPixelBufferGetPixelFormatType(pixelBuffer) == kCVPixelFormatType_32ARGB)
        }

        XCTContext.runActivity(named: "Create 32ARGB 1,170x2,532") { _ in
            let pixelBuffer = try! factory.makePixelBuffer(
                width: 1_170,
                height: 2_532,
                extent: .zero,
                pixelFormatType: ._32ARGB
            )
            XCTAssert(CVPixelBufferGetWidth(pixelBuffer) == 1_170)
            XCTAssert(CVPixelBufferGetHeight(pixelBuffer) == 2_532)
            XCTAssert(CVPixelBufferGetPixelFormatType(pixelBuffer) == kCVPixelFormatType_32ARGB)
        }

        XCTContext.runActivity(named: "Create 420YpCbCr8BiPlanarFullRange 100x100") { _ in
            let pixelBuffer = try! factory.makePixelBuffer(
                width: 100,
                height: 100,
                extent: .zero,
                pixelFormatType: ._420YpCbCr8BiPlanarFullRange
            )
            XCTAssert(CVPixelBufferGetWidth(pixelBuffer) == 100)
            XCTAssert(CVPixelBufferGetHeight(pixelBuffer) == 100)
            XCTAssert(CVPixelBufferGetPixelFormatType(pixelBuffer) == kCVPixelFormatType_420YpCbCr8BiPlanarFullRange)
        }

        XCTContext.runActivity(named: "Create 420YpCbCr8BiPlanarFullRange 100x150") { _ in
            let pixelBuffer = try! factory.makePixelBuffer(
                width: 100,
                height: 150,
                extent: .zero,
                pixelFormatType: ._420YpCbCr8BiPlanarFullRange
            )
            XCTAssert(CVPixelBufferGetWidth(pixelBuffer) == 100)
            XCTAssert(CVPixelBufferGetHeight(pixelBuffer) == 150)
            XCTAssert(CVPixelBufferGetPixelFormatType(pixelBuffer) == kCVPixelFormatType_420YpCbCr8BiPlanarFullRange)
        }

        XCTContext.runActivity(named: "Create 420YpCbCr8BiPlanarFullRange 1,170x2,532") { _ in
            let pixelBuffer = try! factory.makePixelBuffer(
                width: 1_170,
                height: 2_532,
                extent: .zero,
                pixelFormatType: ._420YpCbCr8BiPlanarFullRange
            )
            XCTAssert(CVPixelBufferGetWidth(pixelBuffer) == 1_170)
            XCTAssert(CVPixelBufferGetHeight(pixelBuffer) == 2_532)
            XCTAssert(CVPixelBufferGetPixelFormatType(pixelBuffer) == kCVPixelFormatType_420YpCbCr8BiPlanarFullRange)
        }
    }

    @MainActor
    func testCreatePixelBuffersWithExtent() {
        let factory = PixelBufferFactory.default

        XCTContext.runActivity(named: "Create 32ARGB 100x100 with extent (top: 10, left: 10, bottom: 10, right: 10)") { _ in
            let pixelBuffer = try! factory.makePixelBuffer(
                width: 100,
                height: 100,
                extent: .init(top: 10, left: 10, bottom: 10, right: 10),
                pixelFormatType: ._32ARGB
            )
            XCTAssert(CVPixelBufferGetWidth(pixelBuffer) == 100)
            XCTAssert(CVPixelBufferGetHeight(pixelBuffer) == 100)
            XCTAssert(CVPixelBufferGetPixelFormatType(pixelBuffer) == kCVPixelFormatType_32ARGB)
            var extraCloumnsOnLeft: Int = 0
            var extraCloumnsOnRight: Int = 0
            var extraRowsOnTop: Int = 0
            var extraRowsOnBottom: Int = 0
            CVPixelBufferGetExtendedPixels(pixelBuffer, &extraCloumnsOnLeft, &extraCloumnsOnRight, &extraRowsOnTop, &extraRowsOnBottom)
            XCTAssert(extraCloumnsOnLeft == 10)
            XCTAssert(extraCloumnsOnRight == 10)
            XCTAssert(extraRowsOnTop == 10)
            XCTAssert(extraRowsOnBottom == 10)
        }

        XCTContext.runActivity(named: "Create 32ARGB 100x100 with extent (top: 5, left: 6, bottom: 7, right: 8)") { _ in
            let pixelBuffer = try! factory.makePixelBuffer(
                width: 100,
                height: 100,
                extent: .init(top: 5, left: 6, bottom: 7, right: 8),
                pixelFormatType: ._32ARGB
            )
            XCTAssert(CVPixelBufferGetWidth(pixelBuffer) == 100)
            XCTAssert(CVPixelBufferGetHeight(pixelBuffer) == 100)
            XCTAssert(CVPixelBufferGetPixelFormatType(pixelBuffer) == kCVPixelFormatType_32ARGB)
            var extraCloumnsOnLeft: Int = 0
            var extraCloumnsOnRight: Int = 0
            var extraRowsOnTop: Int = 0
            var extraRowsOnBottom: Int = 0
            CVPixelBufferGetExtendedPixels(pixelBuffer, &extraCloumnsOnLeft, &extraCloumnsOnRight, &extraRowsOnTop, &extraRowsOnBottom)
            XCTAssert(extraCloumnsOnLeft == 6)
            XCTAssert(extraCloumnsOnRight == 8)
            XCTAssert(extraRowsOnTop == 5)
            XCTAssert(extraRowsOnBottom == 7)
        }

        XCTContext.runActivity(named: "Create 420YpCbCr8BiPlanarFullRange 100x100 with extent (top: 5, left: 6, bottom: 7, right: 8)") { _ in
            let pixelBuffer = try! factory.makePixelBuffer(
                width: 100,
                height: 100,
                extent: .init(top: 5, left: 6, bottom: 7, right: 8),
                pixelFormatType: ._420YpCbCr8BiPlanarFullRange
            )
            XCTAssert(CVPixelBufferGetWidth(pixelBuffer) == 100)
            XCTAssert(CVPixelBufferGetHeight(pixelBuffer) == 100)
            XCTAssert(CVPixelBufferGetPixelFormatType(pixelBuffer) == kCVPixelFormatType_420YpCbCr8BiPlanarFullRange)
            var extraCloumnsOnLeft: Int = 0
            var extraCloumnsOnRight: Int = 0
            var extraRowsOnTop: Int = 0
            var extraRowsOnBottom: Int = 0
            CVPixelBufferGetExtendedPixels(pixelBuffer, &extraCloumnsOnLeft, &extraCloumnsOnRight, &extraRowsOnTop, &extraRowsOnBottom)
            XCTAssert(extraCloumnsOnLeft == 6)
            XCTAssert(extraCloumnsOnRight == 8)
            XCTAssert(extraRowsOnTop == 5)
            XCTAssert(extraRowsOnBottom == 7)
        }
    }

    @MainActor
    func testConvertPixelBuffers() {
        let canvasFactory = CanvasFactory()
        let pixelBufferFactory = PixelBufferFactory.default

        XCTContext.runActivity(named: "Convert 32ARGB to 420YpCbCr8BiPlanarFullRange 100x100") { _ in
            let canvas = try! canvasFactory.makeCanvas(width: 100, height: 100, extent: .zero)
            let pixelBuffer = try! pixelBufferFactory.make420YpCbCr8BiPlanarFullRangePixelBuffer(from: canvas)
            XCTAssert(CVPixelBufferGetWidth(pixelBuffer) == 100)
            XCTAssert(CVPixelBufferGetHeight(pixelBuffer) == 100)
            XCTAssert(CVPixelBufferGetPixelFormatType(pixelBuffer) == kCVPixelFormatType_420YpCbCr8BiPlanarFullRange)
        }

        XCTContext.runActivity(named: "Convert 32ARGB to 420YpCbCr8BiPlanarFullRange 150x150") { _ in
            let canvas = try! canvasFactory.makeCanvas(width: 150, height: 150, extent: .zero)
            let pixelBuffer = try! pixelBufferFactory.make420YpCbCr8BiPlanarFullRangePixelBuffer(from: canvas)
            XCTAssert(CVPixelBufferGetWidth(pixelBuffer) == 150)
            XCTAssert(CVPixelBufferGetHeight(pixelBuffer) == 150)
            XCTAssert(CVPixelBufferGetPixelFormatType(pixelBuffer) == kCVPixelFormatType_420YpCbCr8BiPlanarFullRange)
        }

        XCTContext.runActivity(named: "Convert 32ARGB to 420YpCbCr8BiPlanarFullRange 100x100 with extent") { _ in
            let canvas = try! canvasFactory.makeCanvas(width: 100, height: 100, extent: .init(top: 5, left: 6, bottom: 7, right: 8))
            let pixelBuffer = try! pixelBufferFactory.make420YpCbCr8BiPlanarFullRangePixelBuffer(from: canvas)
            XCTAssert(CVPixelBufferGetWidth(pixelBuffer) == 100)
            XCTAssert(CVPixelBufferGetHeight(pixelBuffer) == 100)
            XCTAssert(CVPixelBufferGetPixelFormatType(pixelBuffer) == kCVPixelFormatType_420YpCbCr8BiPlanarFullRange)
            var extraCloumnsOnLeft: Int = 0
            var extraCloumnsOnRight: Int = 0
            var extraRowsOnTop: Int = 0
            var extraRowsOnBottom: Int = 0
            CVPixelBufferGetExtendedPixels(pixelBuffer, &extraCloumnsOnLeft, &extraCloumnsOnRight, &extraRowsOnTop, &extraRowsOnBottom)
            XCTAssert(extraCloumnsOnLeft == 6)
            XCTAssert(extraCloumnsOnRight == 8)
            XCTAssert(extraRowsOnTop == 5)
            XCTAssert(extraRowsOnBottom == 7)
        }
    }
}
