//
//  LCM.swift
//  Day13
//
//  Created by Marc-Antoine Malépart on 2020-12-13.
//

import Foundation

func greatestCommonDivisor(_ x: Int64, _ y: Int64) -> Int64 {
    var a: Int64 = 0
    var b = max(x, y)
    var r = min(x, y)
    
    while r != 0 {
        a = b
        b = r
        r = a % b
    }
    
    return b
}

func leastCommonMultiple(_ x: Int64, _ y: Int64) -> Int64 {
    return abs(x * y) / greatestCommonDivisor(x, y)
}
