//
//  File.swift
//  
//
//  Created by Adrian Milliner on 03/06/2023.
//

import Foundation



public struct SC2 {
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
    

}
