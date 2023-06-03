

public struct SC3 {

    static let START = 100_000
    
    func doRaw(_ n:Int) -> Int {
        n/2
    }
    
    
    func doNormal() {
        
        func abc(_ n:Int) -> Int {
            guard n>0 else { return 0 }
            _ = doRaw(n)
            return n+abc(n-1)
        }
        let k = abc(SC3.START)
        print("Normal k=\(k)")
    }
    
    func doAsync() async {
        func abc(_ n:Int) async -> Int {
            guard n>0 else { return 0 }
            _ = doRaw(n)
            return await n + abc(n-1)
        }
        let k = await abc(SC3.START)
        print("Async k=\(k)")
    }
    
    
    static func main() {
        print("Hello, world")
    }
    
}
