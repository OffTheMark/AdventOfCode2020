//
//  main.swift
//  Day7
//
//  Created by Marc-Antoine Malépart on 2020-12-07.
//

import Foundation
import AdventOfCodeUtilities
import ArgumentParser
import SwiftDataStructures

struct Day7: DayCommand {
    @Argument(help: "Puzzle input path")
    var puzzleInputPath: String
    
    func run() throws {
        let lines = try readLines()
        
        let part1Solution = part1(with: lines)
        printTitle("Part 1", level: .title1)
        print("Count:", part1Solution, terminator: "\n\n")
    }
    
    func part1(with lines: [String]) -> Int {
        let rulesByLuggage: [Luggage: LuggageRule] = lines
            .compactMap({ LuggageRule(rawValue: $0) })
            .reduce(into: [:], { result, rule in
                result[rule.luggage] = rule
            })
        var soughtLuggages: Set<Luggage> = [.shinyGold]
        
        while true {
            let luggagesDirectlyContainingSought = rulesByLuggage
                .filter({ (luggage, rule) in
                    guard !soughtLuggages.contains(luggage) else {
                        return false
                    }
                    
                    let intersection = soughtLuggages.intersection(rule.distinctContents)
                    return !intersection.isEmpty
                })
                .map({ $0.key })
            
            if luggagesDirectlyContainingSought.isEmpty {
                break
            }
            
            soughtLuggages.formUnion(luggagesDirectlyContainingSought)
        }
        
        return soughtLuggages.subtracting([.shinyGold]).count
    }
}

Day7.main()
