//
//  Instruction.swift
//  Day8
//
//  Created by Marc-Antoine Malépart on 2020-12-08.
//

import Foundation

struct Instruction {
    let operation: Operation
    let argument: Int
}

extension Instruction {
    init?(rawValue: String) {
        let parts = rawValue.components(separatedBy: " ")
        
        guard parts.count == 2 else {
            return nil
        }
        
        guard let operation = Operation(rawValue: parts[0]) else {
            return nil
        }
        
        guard let argument = Int(parts[1]) else {
            return nil
        }
        
        self.operation = operation
        self.argument = argument
    }
}

enum Operation: String {
    case accumulate = "acc"
    case jump = "jmp"
    case noOperation = "nop"
}
