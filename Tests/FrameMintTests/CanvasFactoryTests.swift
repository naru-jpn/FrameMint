import XCTest
@testable import FrameMint

final class CanvasFactoryTests: XCTestCase {
    @MainActor
    func testCreateCanvas() async {
        let factory = CanvasFactory()

        XCTContext.runActivity(named: "Create canvas 100x100") { _ in
            let canvas = try! factory.makeCanvas(width: 100, height: 100, extent: .zero)
            XCTAssertEqual(canvas.width, 100)
            XCTAssertEqual(canvas.height, 100)
        }

        XCTContext.runActivity(named: "Create canvas 150x150") { _ in
            let canvas = try! factory.makeCanvas(width: 150, height: 150, extent: .zero)
            XCTAssertEqual(canvas.width, 150)
            XCTAssertEqual(canvas.height, 150)
        }
    }
}
