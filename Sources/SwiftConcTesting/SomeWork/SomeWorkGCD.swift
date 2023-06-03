import Foundation

/// Uses Grand Central Dispatch to run workItem n times and return
/// the average of the result.
public struct SomeWorkGCD {
    
    public init() {}
    
    public func go(_ count:Int) -> Double {
        let group = DispatchGroup()
        //let dq = DispatchQueue.global()
        let dq = DispatchQueue(label: "Hello", attributes: .concurrent)
        var sum = 0.0
        
        for _ in 1...count {
            group.enter()
            dq.async {
                let result = workItem()
                dq.async(flags:.barrier) {
                    sum += result
                    group.leave()
                }
            }
        }
        
        group.wait()
        
        return sum / Double(count)
    }
}
