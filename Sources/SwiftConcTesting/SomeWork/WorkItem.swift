
func computeEulerNumber(_ n:Int) -> Double {
    var e = 1.0
    for i in 1...n {
        let f = e + 1.0 / Double(fact(i))
        if e == f { break }
        e = f
    }
    return e
    
    func fact(_ n:Int) -> Int {
        var r = n
        var n = n
        while n > 1 {
            n -= 1
            r *= n
        }
        return r
    }
}

func workItem() -> Double {
    var result = 0.0
    for n in 1...1000 {
        result += computeEulerNumber(n)
    }
    return result
}
