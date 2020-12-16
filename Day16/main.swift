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
        
        let invalidValuesForAnyFieldByTicketIndex = part1(with: input)
        let part1Solution = invalidValuesForAnyFieldByTicketIndex.values.reduce(into: 0, { result, invalidValues in
            result += invalidValues.reduce(0, +)
        })
        
        printTitle("Part 1", level: .title1)
        print("Error rate:", part1Solution, terminator: "\n\n")
        
        for index in invalidValuesForAnyFieldByTicketIndex.keys.sorted(by: >) {
            input.otherTickets.remove(at: index)
        }
        
        let part2Solution = part2(with: input)
        printTitle("Part 2", level: .title1)
        print("Product:", part2Solution)
    }
    
    func part1(with input: Input) -> [Int: [Int]] {
        var invalidValuesForAnyFieldByTicketIndex = [Int: [Int]]()
        
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
            
            if valuesMatchingNoRule.isEmpty  == false {
                invalidValuesForAnyFieldByTicketIndex[index] = valuesMatchingNoRule
            }
        }
        
        return invalidValuesForAnyFieldByTicketIndex
    }
    
    func part2(with input: Input) -> Int {
        var possibleIndicesByField = [String: Set<Int>]()
        
        for ticket in input.otherTickets {
            var possibilitiesForTicket = [String: Set<Int>]()
            
            for (fieldName, rule) in input.rulesByField {
                let possibleIndices: Set<Int> = ticket.numbers.enumerated().reduce(into: [], { result, element in
                    let (index, number) = element
                    
                    if rule.isIncluded(number) {
                        result.insert(index)
                    }
                })
                
                possibilitiesForTicket[fieldName] = possibleIndices
            }
            
            if possibleIndicesByField.isEmpty {
                possibleIndicesByField = possibilitiesForTicket
                continue
            }
            
            for fieldName in possibleIndicesByField.keys {
                possibleIndicesByField[fieldName, default: []].formIntersection(possibilitiesForTicket[fieldName]!)
            }
        }
        
        var confirmedIndicesByField = [String: Int]()
        var confirmedMatches: [(fieldName: String, index: Int)] = possibleIndicesByField.compactMap({ (fieldName, indices) in
            if confirmedIndicesByField.keys.contains(fieldName) {
                return nil
            }
            
            guard indices.count == 1, let index = indices.first else {
                return nil
            }
            
            return (fieldName, index)
        })
        
        while confirmedMatches.isEmpty == false {
            for (fieldName, index) in confirmedMatches {
                confirmedIndicesByField[fieldName] = index
                
                possibleIndicesByField.removeValue(forKey: fieldName)
                
                for (fieldName, indices) in possibleIndicesByField {
                    possibleIndicesByField[fieldName] = indices.subtracting([index])
                }
            }
            
            confirmedMatches = possibleIndicesByField.compactMap({ (fieldName, indices) in
                if confirmedIndicesByField.keys.contains(fieldName) {
                    return nil
                }
                
                guard indices.count == 1, let index = indices.first else {
                    return nil
                }
                
                return (fieldName, index)
            })
        }
        
        let numbersByIndex: [Int: Int] = input.ticket.numbers.enumerated().reduce(into: [:], { result, element in
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
