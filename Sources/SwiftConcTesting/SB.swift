import Foundation

public struct SB  {
    
    public static func main() async throws {
        print("Process Started")

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

