import XCTest
@testable import conctest

final class conctestNormal: XCTestCase {
    func testNormal() throws {
        let testee = conctest()
        measure {
            testee.doNormal()
        }
    }

    func testAsync() throws {
        let testee = conctest()
        
        
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

