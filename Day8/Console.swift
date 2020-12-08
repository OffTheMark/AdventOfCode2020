//
//  Console.swift
//  Day8
//
//  Created by Marc-Antoine Malépart on 2020-12-08.
//

import Foundation

class Console {
    private(set) var accumulator: Int
    private(set) var currentIndex: Int
    let instructions: [Instruction]
    
    var canExecuteNextInstruction: Bool {
        instructions.indices.contains(currentIndex)
    }
    
    var currentInstruction: Instruction { instructions[currentIndex] }
    
    init(instructions: [Instruction], accumulator: Int = 0) {
        self.instructions = instructions
        self.currentIndex = instructions.startIndex
        self.accumulator = accumulator
    }
    
    func executeToCompletion() -> ExecutionResult {
        var visitedInstructions = Set<Int>()
        
        while canExecuteNextInstruction {
            let (inserted, _) = visitedInstructions.insert(currentIndex)
            
            if !inserted {
                return .stuckInLoop
            }
            
            executeNextInstruction()
        }
        
        if currentIndex == instructions.endIndex {
            return .safelyTerminated
        }
        else {
            return .invalid
        }
    }
    
    func executeNextInstruction() {
        assert(canExecuteNextInstruction, "Current index \(currentIndex) is out of bounds: \(instructions.indices)")
        
        let instruction = instructions[currentIndex]
        
        switch instruction.operation {
        case .accumulate:
            accumulator += instruction.argument
            
        case .jump:
            currentIndex = instructions.index(currentIndex, offsetBy: instruction.argument)
            return
            
        case .noOperation:
            break
        }
        
        currentIndex = instructions.index(after: currentIndex)
    }
    
    enum ExecutionResult {
        case safelyTerminated
        case invalid
        case stuckInLoop
    }
}

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

extension Instruction: CustomStringConvertible {
    var description: String {
        let formatter = NumberFormatter()
        formatter.positivePrefix = "+"
        
        return "\(operation.rawValue) \(formatter.string(from: NSNumber(value: argument))!)"
    }
}

enum Operation: String {
    case accumulate = "acc"
    case jump = "jmp"
    case noOperation = "nop"
}
