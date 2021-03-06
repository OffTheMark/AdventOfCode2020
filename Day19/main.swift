//
//  main.swift
//  Day19
//
//  Created by Marc-Antoine Malépart on 2020-12-19.
//

import Foundation
import AdventOfCodeUtilities
import ArgumentParser
import Algorithms

enum RuleArgument {
    case character(Character)
    case index(Int)
}

typealias Rule = [[RuleArgument]]

struct Day19: DayCommand {
    @Argument(help: "Puzzle input path")
    var puzzleInputPath: String
    
    func run() throws {
        let fileContent = try readFile()
        let parts = fileContent.components(separatedBy: "\n\n")
        let messages = parts[1].components(separatedBy: .newlines)
        let rulesByIndex = rules(from: parts[0])
        
        let part1Solution = part1(with: messages, matching: rulesByIndex)
        printTitle("Part 1", level: .title1)
        print("Count:", part1Solution, terminator: "\n\n")
        
        let part2Solution = part2(with: messages, matching: rulesByIndex)
        printTitle("Part 2", level: .title1)
        print("Count:", part2Solution)
    }
    
    func rules(from text: String) -> [Int: Rule] {
        var rulesByIndex = [Int: Rule]()
        
        for line in text.components(separatedBy: .newlines) {
            var parts = line.components(separatedBy: ": ")
            
            guard parts.count == 2, let index = Int(parts[0]) else {
                continue
            }
            
            parts = parts[1].components(separatedBy: " | ")
            let rule: Rule = parts.map({ part in
                return part.components(separatedBy: " ")
                    .compactMap({ rawValue in
                        if rawValue.hasPrefix("\""), rawValue.hasSuffix("\"") {
                            let characterIndex = rawValue.index(after: rawValue.startIndex)
                            return .character(rawValue[characterIndex])
                        }
                        
                        return Int(rawValue).map({ RuleArgument.index($0) })
                    })
            })
            
            rulesByIndex[index] = rule
        }
        
        return rulesByIndex
    }
    
    func part1(with messages: [String], matching rulesByIndex: [Int: Rule]) -> Int {
        return messages.count(where: { message in
            let matches = self.matches(
                in: message,
                rulesByIndex: rulesByIndex,
                rule: rulesByIndex[0]!,
                position: 0
            )
            return matches.contains(message.count)
        })
    }
    
    func part2(with messages: [String], matching rulesByIndex: [Int: Rule]) -> Int {
        var rulesByIndex = rulesByIndex
        rulesByIndex[8] = [[.index(42)], [.index(42), .index(8)]]
        rulesByIndex[11] = [[.index(42), .index(31)], [.index(42), .index(11), .index(31)]]
        
        return messages.count(where: { message in
            let matches = self.matches(
                in: message,
                rulesByIndex: rulesByIndex,
                rule: rulesByIndex[0]!,
                position: 0
            )
            return matches.contains(message.count)
        })
    }
    
    /// The algorithm is taken from [this submission.](https://www.reddit.com/r/adventofcode/comments/kg1mro/2020_day_19_solutions/ggdb2rg?utm_source=share&utm_medium=web2x&context=3)
    func matches(in message: String, rulesByIndex: [Int: Rule], rule: Rule, position: Int) -> [Int] {
        var matches = [Int]()
        
        for attempt in rule {
            var positions = [position]
            
            for argument in attempt {
                var newPositions = [Int]()
                
                for position in positions {
                    switch argument {
                    case .character(let character):
                        guard position < message.count else {
                            break
                        }
                        
                        let searchIndex = message.index(message.startIndex, offsetBy: position)
                        
                        if message[searchIndex] == character {
                            newPositions.append(position + 1)
                        }
                        
                    case .index(let index):
                        let subMatches = self.matches(
                            in: message,
                            rulesByIndex: rulesByIndex,
                            rule: rulesByIndex[index]!,
                            position: position
                        )
                        newPositions.append(contentsOf: subMatches)
                    }
                }
                
                positions = newPositions
            }
            
            matches.append(contentsOf: positions)
        }
        
        return matches
    }
}

Day19.main()
