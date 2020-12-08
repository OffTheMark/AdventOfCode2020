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
        
        let part1Solution = part1(with: instructions)
        printTitle("Title 1", level: .title1)
        print("Accumulator:", part1Solution, terminator: "\n\n")
    }
    
    func part1(with instructions: [Instruction]) -> Int {
        var accumulator = 0
        var currentIndex = instructions.startIndex
        
        var visitedInstructions = Set<Int>()
        
        while currentIndex < instructions.endIndex {
            let instruction = instructions[currentIndex]
            
            let (inserted, _) = visitedInstructions.insert(currentIndex)
            if !inserted {
                return accumulator
            }
            
            switch instruction.operation {
            case .accumulate:
                accumulator += instruction.argument
                currentIndex = instructions.index(after: currentIndex)
                
            case .noOperation:
                currentIndex = instructions.index(after: currentIndex)
                
            case .jump:
                currentIndex = instructions.index(currentIndex, offsetBy: instruction.argument)
            }
        }
        
        fatalError("Program terminated")
    }
}

Day8.main()
