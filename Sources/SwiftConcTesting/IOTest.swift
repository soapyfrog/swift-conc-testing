
import Foundation



public class IOTest {
    var savedStdinTermIos:termios=termios()
    public init() {
        withUnsafeMutablePointer(to: &savedStdinTermIos) { p in
            tcgetattr(FileHandle.standardInput.fileDescriptor, p)
            return
        }
        
        var t = savedStdinTermIos
        withUnsafeMutablePointer(to: &t) { p in
//            tcgetattr(FileHandle.standardInput.fileDescriptor, p)
            p.pointee.c_lflag &= ~UInt(ECHO | ICANON | IEXTEN | ISIG)
            p.pointee.c_iflag &= ~UInt(BRKINT | ICRNL | INPCK | ISTRIP | IXON)
            tcsetattr(FileHandle.standardInput.fileDescriptor, TCSAFLUSH, p)
        }
    }
    deinit {
        _ = withUnsafeMutablePointer(to: &savedStdinTermIos) { p in
            tcsetattr(FileHandle.standardInput.fileDescriptor, TCSAFLUSH, p)
        }
    }
    
    
    public func go() {
        let io:IO = SimpleIO()
        
        io.write("Type a line: ")
        let line = io.readLine(echo:true) ?? "<EOF>"
        io.write("\n\rGot: \(line)\r\n")
        
        print("Type characters, end with q, or EOF")
        
        while let c = io.read(echo:false) {
            io.write("\(c)")
            if c == "\r" { io.write("\n") }
            if c == "q" {
                io.write("\r\nGot q, ending... ")
                break
            }
        }
        
        print("Bye")
    }
}



protocol IO {
    /// Blocking read of a character or nil if EOF
    func read(echo:Bool) -> Character?
    /// Blocking read of a string of nil if EOF
    func readLine(echo:Bool) -> String?
    
    /// write characters in string
    func write(_ s:any StringProtocol)
}


/// This SimpleIO puts the stdin into raw mode, then uses
/// `FileHandle.standardInput.availableData` to get any characters,
/// vending them out one at a time for `read` and up until a `cr`
/// for `readLine`
///
/// Implements `write` using `FileHandle.standardOutput.write` to avoid
/// Swift's print doing any buffering.
///
/// Restores the terminal back to normal on `deinit`.
class SimpleIO : IO {
    
    private var readAhead:String = ""
    
    func read(echo:Bool) -> Character? {
        if readAhead.isEmpty {
            readAhead = blockReadAvailable()
        }
        if readAhead.isEmpty {
            return nil
        }
        if echo {
            write(String(readAhead.prefix(1)))
        }
        return readAhead.removeFirst()
    }
    
    
    func readLine(echo:Bool) -> String? {
        var result = ""
        while let c = read(echo: echo), c != "\r" {
            result.append(c)
        }
        return result.isEmpty ? nil : result
    }
    
    func write(_ s:any StringProtocol) {
        if let data = s.data(using: .utf8, allowLossyConversion: true) {
            do {
                try FileHandle.standardOutput.write(contentsOf: data)
            }
            catch {
                fatalError("Unable to write to standard output")
            }
        }
        else {
            fatalError("String not convertible to UTF8 - should not be possible")
        }
    }
    
    
    private func blockReadAvailable() -> String {
        let d = FileHandle.standardInput.availableData
        return String(data: d, encoding: .utf8) ?? ""
    }
}
