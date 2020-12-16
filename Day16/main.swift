//
//  main.swift
//  Day16
//
//  Created by Marc-Antoine Malépart on 2020-12-16.
//

import Foundation
import AdventOfCodeUtilities
import ArgumentParser
import Algorithms

struct Day16: DayCommand {
    @Argument(help: "Puzzle input path")
    var puzzleInputPath: String
    
    func run() throws {
        let rawValue = try readFile()
        let input = Input(rawValue: rawValue)!
        
        let part1Solution = part1(with: input)
        printTitle("Title 1", level: .title1)
        print("Error rate:", part1Solution, terminator: "\n\n")
    }
    
    func part1(with input: Input) -> Int {
        var invalidValuesForAnyField = [Int]()
        
        for ticket in input.othetTickets {
            let numberOfValidRulesByValue: [Int: Int] = product(ticket.numbers, input.rulesByField.values)
                .reduce(into: [:], { result, pair in
                    let (number, rule) = pair
                    
                    if rule.isIncluded(number) {
                        result[number, default: 0] += 1
                    }
                    else {
                        result[number, default: 0] += 0
                    }
                })
            
            let valuesMatchingNoRule: [Int] = numberOfValidRulesByValue.compactMap({ (number, count) in
                if count == 0 {
                    return number
                }
                
                return nil
            })
            invalidValuesForAnyField.append(contentsOf: valuesMatchingNoRule)
        }
        
        return invalidValuesForAnyField.reduce(0, +)
    }
}

Day16.main()
