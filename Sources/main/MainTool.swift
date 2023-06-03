import SwiftConcTesting

/*
 Has to be in a file not called "main" to avoid the
 "Can't have a @main in a module with top level content" or some-such
 nonsense.
 
 */
@main struct Main {
    static func main() async throws {
        let k = ContinuousClock()

        let count = 100000
        var result = 0.0

        var time = await k.measure {
            result = await SomeWorkSC().go(count)
        }
        print("SC result=\(result) time=\(time)")
        
        
        time = k.measure {
            result = SomeWorkGCD().go(count)
        }
        print("GCD result=\(result) time=\(time)")

        
    }
    
    
    /*
     Running on my M1 MBP..
     
     √ swift-conc-testing % swift run -c release
     Building for production...
     Build complete! (0.12s)
     SC result=2717.281828461692 time=1.865593875 seconds
     GCD result=2717.281828461692 time=1.912462083 seconds
     
     Slightly slower wall clock time in GCD, but I am doing
     a clunky result collection in GCD.
     
     */
    
}
 
