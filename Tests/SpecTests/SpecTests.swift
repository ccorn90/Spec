import XCTest
@testable import Spec

class SpecTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssertEqual(Spec().text, "Hello, World!")
    }


    static var allTests = [
        ("testExample", testExample),
    ]
}
