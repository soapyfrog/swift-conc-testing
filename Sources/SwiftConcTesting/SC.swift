//
//  File.swift
//  
//
//  Created by Adrian Milliner on 03/06/2023.
//

import Foundation


public struct SC {
    
    
    /// Looks at creating concurrent tasks in a group and waiting for them to complete.
    public static func bollox() async -> Bool {
        
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
