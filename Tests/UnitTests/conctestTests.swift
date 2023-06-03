import XCTest
@testable import SwiftConcTesting

final class StuffTest: XCTestCase {
    func testNormal() throws {
        let testee = SC3()
        measure {
            testee.doNormal()
        }
    }

    func testAsync() throws {
        let testee = SC3()
        
        
        self.measureMetrics([.wallClockTime], automaticallyStartMeasuring: false) {
            let exp = expectation(description: "Done")
            startMeasuring()
            Task {
                await testee.doAsync()
                exp.fulfill()
            }
            wait(for: [exp], timeout: 200.0)
            stopMeasuring()
        }
    }
}

