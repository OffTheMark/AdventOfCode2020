//
//  main.swift
//  Day7
//
//  Created by Marc-Antoine Malépart on 2020-12-07.
//

import Foundation
import AdventOfCodeUtilities
import ArgumentParser

struct Day7: DayCommand {
    @Argument(help: "Puzzle input path")
    var puzzleInputPath: String
    
    func run() throws {
        let rules = try readLines().compactMap({ LuggageRule(rawValue: $0) })
        
        let part1Solution = part1(with: rules)
        printTitle("Part 1", level: .title1)
        print("Count:", part1Solution, terminator: "\n\n")
        
        let part2Solution = part2(with: rules)
        printTitle("Part 2", level: .title1)
        print("Count:", part2Solution)
    }
    
    func part1(with rules: [LuggageRule]) -> Int {
        let rulesByLuggage: [Luggage: LuggageRule] = rules
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
    
    func part2(with rules: [LuggageRule]) -> Int {
        let rulesByLuggage: [Luggage: LuggageRule] = rules
            .reduce(into: [:], { result, rule in
                result[rule.luggage] = rule
            })
        var memo: [Luggage: Int] = [:]
        
        func totalBags(for root: Luggage) -> Int {
            let rule = rulesByLuggage[root]!
            
            if let countOfLuggage = memo[root] {
                return countOfLuggage
            }
            
            var result = 0
            for (luggage, countOfLuggage) in rule.allowedContents {
                let countOfBags = totalBags(for: luggage)
                result += countOfLuggage * countOfBags + countOfLuggage
            }
            
            memo[root] = result
            
            return result
        }
        
        return totalBags(for: .shinyGold)
    }
}

Day7.main()
