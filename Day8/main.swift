//
//  main.swift
//  Day8
//
//  Created by Marc-Antoine Malépart on 2020-12-08.
//

import Foundation
import AdventOfCodeUtilities
import ArgumentParser

struct Day8: DayCommand {
    @Argument(help: "Puzzle input path")
    var puzzleInputPath: String
    
    func run() throws {
        let instructions = try readLines().compactMap({ Instruction(rawValue: $0) })
        
        let part1Solution = part1(using: instructions)
        printTitle("Title 1", level: .title1)
        print("Accumulator:", part1Solution.accumulator)
        print("Start index of loop:", part1Solution.startIndexOfLoop, terminator: "\n\n")
        
        let part2Solution = part2(using: instructions, startIndexOfLoop: part1Solution.startIndexOfLoop)
        printTitle("Title 2", level: .title1)
        print("Accumulator:", part2Solution.accumulator)
        print("Index of corruption:", part2Solution.indexOfCorruption)
    }
    
    func part1(using instructions: [Instruction]) -> (accumulator: Int, startIndexOfLoop: Int) {
        let console = Console(instructions: instructions)
        
        var visitedInstructions = Set<Int>()
        
        while console.state == .executing {
            let (inserted, _) = visitedInstructions.insert(console.currentIndex)
            if !inserted {
                return (console.accumulator, console.currentIndex)
            }
            
            console.nextInstruction()
        }
        
        fatalError("Program terminated")
    }
    
    func part2(using instructions: [Instruction], startIndexOfLoop: Int) -> (accumulator: Int, indexOfCorruption: Int) {
        let sequenceLeadingToLoop = instructionsLeadingToLoop(startingAt: startIndexOfLoop, using: instructions)
        let possibleCorrections: [(index: Int, instruction: Instruction)] = sequenceLeadingToLoop
            .compactMap({ (index, instruction) in
                switch instruction.operation {
                case .noOperation:
                    return (index, Instruction(operation: .jump, argument: instruction.argument))
                
                case .jump:
                    return (index, Instruction(operation: .noOperation, argument: instruction.argument))
                    
                case .accumulate:
                    return nil
                }
            })
        
        for correction in possibleCorrections {
            var newInstructions = instructions
            newInstructions[correction.index] = correction.instruction
            
            let result = executeToCompletion(instructions: newInstructions)
            
            switch result {
            case .stuckInLoop, .invalid:
                continue
                
            case .corrected(let accumulator):
                return (accumulator, correction.index)
            }
        }
        
        fatalError("Invalid state")
    }
    
    private func instructionsLeadingToLoop(
        startingAt startIndexOfLoop: Int,
        using instructions: [Instruction]
    ) -> [(index: Int, instruction: Instruction)] {
        let console = Console(instructions: instructions)
        var timesStartOfLoopWasEncoutered = 0
        var sequenceLeadingToLoop = [(index: Int, instruction: Instruction)]()
        
        while console.state == .executing {
            let currentInstruction = console.currentInstruction
            
            if console.currentIndex == startIndexOfLoop {
                timesStartOfLoopWasEncoutered += 1
            }
            
            if timesStartOfLoopWasEncoutered == 2 {
                return sequenceLeadingToLoop
            }
            
            sequenceLeadingToLoop.append((console.currentIndex, currentInstruction))
            console.nextInstruction()
        }
        
        fatalError("Invalid state")
    }
    
    private func executeToCompletion(instructions: [Instruction]) -> ExecutionResult {
        let console = Console(instructions: instructions)
        var visitedInstructions = Set<Int>()
        
        while console.state == .executing {
            let (inserted, _) = visitedInstructions.insert(console.currentIndex)
            if !inserted {
                return .stuckInLoop
            }
            
            console.nextInstruction()
        }
        
        switch console.state {
        case .invalid:
            return .invalid
            
        case .safelyTerminated:
            return .corrected(accumulator: console.accumulator)
            
        case .executing:
            fatalError("Invalid state")
        }
    }
    
    enum ExecutionResult {
        case corrected(accumulator: Int)
        case invalid
        case stuckInLoop
    }
}

Day8.main()
