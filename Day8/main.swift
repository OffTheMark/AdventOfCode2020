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
        let console = Console(instructions: instructions)
        
        var visitedInstructions = Set<Int>()
        
        while true {
            let (inserted, _) = visitedInstructions.insert(console.currentIndex)
            if !inserted {
                return console.accumulator
            }
            
            console.nextInstruction()
        }
        
        fatalError("Program terminated")
    }
}

Day8.main()
