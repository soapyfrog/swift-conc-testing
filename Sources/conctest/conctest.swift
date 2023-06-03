

public struct conctest {

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
        let k = abc(conctest.START)
        print("Normal k=\(k)")
    }
    
    func doAsync() async {
        func abc(_ n:Int) async -> Int {
            guard n>0 else { return 0 }
            _ = doRaw(n)
            return await n + abc(n-1)
        }
        let k = await abc(conctest.START)
        print("Async k=\(k)")
    }
    
    
    static func main() {
        print("Hello, world")
    }
    
}
