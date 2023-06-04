import Foundation

public struct SCandSempahores {
    
    public init() {}
        
    /// We'll make this async to ensure we're in a Task
    public func go() async {
        check("go")
        // call a non-async function
        doSomethingSynchronous()
        
        doSomethingExperimental()
        
        check("go end")
    }
    

    func doSomethingSynchronous() {
        check("doSomethingSynchronous")

        let task = Task {
            check("first anon task")
            await somethingAsynchronous()
        }
        
        print("task = \(task)")
        
        Task {
            check("second anon task")
            print (await task.value)
        }
        
    }
    
    func doSomethingExperimental() {
        check("doSomethingExperimental")
        
        let ds = DispatchSemaphore(value: 0)
        Task {
            check("in experimental task")
            // do stuff
            ds.signal()
        }
        if case .timedOut = ds.wait(timeout: .now()+10.0) {
            print("Oops, now what?")
            // if we're in a task, we could cancel it...
            // timeout might indicate a deadlock where current
            // task is preventing the above task from running...
            withUnsafeCurrentTask { t in
                t?.cancel()
            }
        }
        
        check("after experimental task signalled")
    }
    
    @MainActor
    func somethingAsynchronous() async {
        check("somethingAsynchronous")
    }
    
    
    func check(_ s:String) {
        let threadInfo = String(describing: Thread.current)
        print("\(threadInfo) | \(s)")
    }
    
}
