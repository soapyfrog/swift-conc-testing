import Foundation

public struct MainTool  {
    
    public static func main() async throws {
        print("Process Started")

/*
        DispatchQueue.global(qos:.default).async {
            print("Ha!", Thread.current)
        }
        
        print("Ho!", Thread.current)
        Thread.sleep(forTimeInterval: 2.0)
        
        if true { return }
*/        
        if await bollox() {
            return
        }
        
        
        
        if await othermain() {
            return
        }
        

        let vdu = Vdu()
        let sb = SoapyBasic(vdu:vdu)
        
        // This actually works (have to press return though as in cooked mode)
        // Does not call handler on main thread though, so would have to
        // out the data in an actor or something.
        // .. or maybe make this part of Vdu.
        FileHandle.standardInput.readabilityHandler = { h in
            let d = h.availableData
            if !d.isEmpty {
                print(d,Thread.current)
            }
        }
        
        let programTask = Task.detached(priority:.high) {
            try await sb.runProgram()
            return "OK"
        }
        
        // do some other stuff
        for a in 1...500 {
            try await Task.sleep(for: .milliseconds(1350))
            print("a=\(a)")
        }

        let t = try await programTask.value
        
        FileHandle.standardInput.readabilityHandler = nil
        print("Process Ended, \(t)")

    }

    @MainActor
    static func othermain() async -> Bool {
        
        print("othermain start")
                
        // This is really handy to await on something that has some callback
        // handler, like FileHandle's readabilityHandler.
        // It suspends the current thread until something is available.
        let thing = await withUnsafeContinuation {c in
            print("Name? ", terminator: "")
            FileHandle.standardInput.readabilityHandler = { fh in
                let s = String(data: fh.availableData, encoding:.utf8) ?? "Eek"
                c.resume(returning: "Hello \(s)")
            }
        }
        print("thing=\(thing)")
        
        // now do a bunch of sync things, async
        _ = await Task {
            syncFunc("One")
            syncFunc("Two")
            syncFunc("Three")
            return true
        }.value
        
        print("othermain stop")
        return true
    }
    
    
    static func syncFunc(_ s:String) {
        print(s)
    }
    
    
    
    /// Looks at creating concurrent tasks in a group and waiting for them to complete.
    static func bollox() async -> Bool {

        let result = await withTaskGroup(of: Double.self, returning: Double.self) {group in
            for n in 1...1000 {
                group.addTask {
                    something(n)
                }
            }
            
            var ds = 0.0
            for await d in group {
                ds += d
            }
            return ds
        }

        // On Windows, it doesn't get to here and doesn't seem to print "end n=1000" either.
        // it's like it's just not flushing out the stdout buffer.       
        print(result)

        print("======")

        do {
            try await Task.sleep(for:.seconds(2))
        }
        catch {
            print("meh")
        }
        
        return true
        
    }
    static func something(_ n:Int) -> Double {
        print("begin n=\(n) thread=\(Thread.current)")
        var q = 99.9
        for k in 1...(n*100) {
            q += Double(k-1)*q / Double(k+1) / q
        }
        //Thread.sleep(forTimeInterval: Double(2+n%3)/25.0)
        print("  end n=\(n)")
        return q
    }
}






public actor SoapyBasic {
    
    private let vdu:Vdu
    public init(vdu:Vdu) {
        self.vdu = vdu
    }
    
    public func runProgram() async throws {
        await vdu.write("Hello, I'm a program.")
        for a in 1...500 {
            try await Task.sleep(for: .milliseconds(100))
            await vdu.write("Loop \(a)")
            try await Task.sleep(for: .milliseconds(100))
        }
        // TODO: 3 await calls into vdu - can this be combined?
        // vdu.block {
        //   ...
        //   ...
        // }
        // TODO: does it even matter? perhaps if it's an actor.
        await vdu.write("Continue?")
        let answer = try await vdu.input("Y")
        await vdu.write(answer)
    }
    
}

@MainActor
public class Vdu {
    public nonisolated init() {
        
    }
    public func write(_ s:String) async {
        print("log:",s)
    }
    
    public func input(_ s:String)  async throws -> String {
        try await Task.sleep(for:.milliseconds(150))
        return s
    }
}

