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
        print("Corrupted instruction:", part2Solution.corruptedInstruction)
    }
    
    func part1(using instructions: [Instruction]) -> (accumulator: Int, startIndexOfLoop: Int) {
        let console = Console(instructions: instructions)
        
        var visitedInstructions = Set<Int>()
        
        while console.canExecuteNextInstruction {
            let (inserted, _) = visitedInstructions.insert(console.currentIndex)
            if !inserted {
                return (console.accumulator, console.currentIndex)
            }
            
            console.executeNextInstruction()
        }
        
        fatalError("Program terminated")
    }
    
    func part2(
        using instructions: [Instruction],
        startIndexOfLoop: Int
    ) -> (accumulator: Int, indexOfCorruption: Int, corruptedInstruction: Instruction) {
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
            
            let console = Console(instructions: newInstructions)
            let result = console.executeToCompletion()
            
            switch result {
            case .stuckInLoop, .invalid:
                continue
                
            case .safelyTerminated:
                return (console.accumulator, correction.index, instructions[correction.index])
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
        
        while console.canExecuteNextInstruction {
            let currentInstruction = console.currentInstruction
            
            if console.currentIndex == startIndexOfLoop {
                timesStartOfLoopWasEncoutered += 1
            }
            
            if timesStartOfLoopWasEncoutered == 2 {
                return sequenceLeadingToLoop
            }
            
            sequenceLeadingToLoop.append((console.currentIndex, currentInstruction))
            console.executeNextInstruction()
        }
        
        fatalError("Invalid state")
    }
}

Day8.main()
