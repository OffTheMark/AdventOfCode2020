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
        var input = Input(rawValue: rawValue)!
        
        let invalidValuesByTicketIndex = part1(with: input)
        let part1Solution = invalidValuesByTicketIndex.values.reduce(into: 0, { result, invalidValues in
            result += invalidValues.reduce(0, +)
        })
        
        printTitle("Part 1", level: .title1)
        print("Error rate:", part1Solution, terminator: "\n\n")
        
        for index in invalidValuesByTicketIndex.keys.sorted(by: >) {
            input.otherTickets.remove(at: index)
        }
        
        let part2Solution = part2(with: input)
        printTitle("Part 2", level: .title1)
        print("Product:", part2Solution)
    }
    
    func part1(with input: Input) -> [Int: [Int]] {
        var invalidValuesByTicketIndex = [Int: [Int]]()
        
        for (index, ticket) in input.otherTickets.enumerated() {
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
            
            if valuesMatchingNoRule.isEmpty == false {
                invalidValuesByTicketIndex[index] = valuesMatchingNoRule
            }
        }
        
        return invalidValuesByTicketIndex
    }
    
    func part2(with input: Input) -> Int {
        var possibleMatchesByField = [String: Set<Int>]()
        
        for ticket in input.otherTickets {
            var possibleMatchesForTicket = [String: Set<Int>]()
            
            for (fieldName, rule) in input.rulesByField {
                let possibleIndices: Set<Int> = ticket.numbers.enumerated().reduce(into: [], { result, element in
                    let (index, number) = element
                    
                    if rule.isIncluded(number) {
                        result.insert(index)
                    }
                })
                
                possibleMatchesForTicket[fieldName] = possibleIndices
            }
            
            possibleMatchesByField.merge(possibleMatchesForTicket, uniquingKeysWith: { fieldMatches, ticketMatches in
                return fieldMatches.intersection(ticketMatches)
            })
        }
        
        var confirmedIndicesByField = [String: Int]()
        
        while possibleMatchesByField.isEmpty == false {
            let confirmedMatches: [(fieldName: String, index: Int)] = possibleMatchesByField
                .compactMap({ (fieldName, indices) in
                    guard indices.count == 1, let index = indices.first else {
                        return nil
                    }
                    
                    return (fieldName, index)
                })
            
            for (fieldName, index) in confirmedMatches {
                confirmedIndicesByField[fieldName] = index
                possibleMatchesByField.removeValue(forKey: fieldName)
                
                for (fieldName, indices) in possibleMatchesByField {
                    possibleMatchesByField[fieldName] = indices.subtracting([index])
                }
            }
        }
        
        let numbersByIndex: [Int: Int] = input.ticket.numbers.enumerated()
            .reduce(into: [:], { result, element in
                let (index, number) = element
                result[index] = number
            })
        
        return confirmedIndicesByField.reduce(into: 1, { product, element in
            let (fieldName, index) = element
            
            guard fieldName.starts(with: "departure") else {
                return
            }
            
            let fieldValue = numbersByIndex[index, default: 1]
            product *= fieldValue
        })
    }
}

Day16.main()
