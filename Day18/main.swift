//
//  main.swift
//  Day18
//
//  Created by Marc-Antoine Malépart on 2020-12-18.
//

import Foundation
import AdventOfCodeUtilities
import ArgumentParser
import Expression
import SwiftDataStructures

struct Day18: DayCommand {
    @Argument(help: "Puzzle input path")
    var puzzleInputPath: String
    
    func run() throws {
        let lines = try readLines()
        
        let part1Solution = try part1(with: lines)
        printTitle("Part 1", level: .title1)
        print("Sum:", part1Solution, terminator: "\n\n")
    }
    
    func part1(with lines: [String]) throws -> Int {
        return try lines
            .reduce(into: 0, { result, line in
                let expression = MathExpression(line)
                let value = try expression.evaluate()
                
                result += value
            })
    }
}

Day18.main()
