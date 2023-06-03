import XCTest
@testable import SwiftConcTesting

final class StuffTest: XCTestCase {
    func testNormal() throws {
        let testee = SCRecursion()
        measure {
            testee.doNormal()
        }
    }

    func testAsync() throws {
        let testee = SCRecursion()
        
        
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
    
    /*
     M1 Mac -c performance
     
     Async  average: 0.007
     Normal average: 0.002
     
     So clear that adding async all the way down is going to ruin
     performance, on the off chance you might want to do something
     async later on.
     */
}

