
/// Uses Structured Concurrency to run workItem n times and return
/// the average of the result.
public struct SomeWorkSC {
    
    public init(){}
    
    public func go(_ count: Int) async -> Double {
        
        let result = await withTaskGroup(of: Double.self, returning: Double.self) {group in
            for _ in 1...count {
                group.addTask {
                    return workItem()
                }
            }
            
            var sum = 0.0
            for await d in group {
                sum += d
            }
            
            return sum / Double(count)
        }

        return result
    }
}
