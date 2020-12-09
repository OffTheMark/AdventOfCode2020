//
//  main.swift
//  Day9
//
//  Created by Marc-Antoine Malépart on 2020-12-09.
//

import Foundation
import AdventOfCodeUtilities
import ArgumentParser
import Algorithms

struct Day9: DayCommand {
    @Argument(help: "Puzzle input path")
    var puzzleInputPath: String
    
    func run() throws {
        let numbers = try readLines().compactMap({ Int($0) })
        
        let part1Solution = part1(using: numbers)
        printTitle("Part 1", level: .title1)
        print("Invalid number:", part1Solution, terminator: "\n\n")
        
        let part2Solution = part2(withInvalidNumber: part1Solution, using: numbers)
        printTitle("Part 1", level: .title1)
        print("Invalid number:", part2Solution)
    }
    
    func part1(using numbers: [Int]) -> Int {
        var currentIndex = 25
        let preamble = numbers[0 ..< currentIndex]
        
        var knownSums: Set<Int> = preamble.combinations(ofCount: 2)
            .reduce(into: [], { result, combination in
                let sum = combination.reduce(0, +)
                result.insert(sum)
            })
        
        while knownSums.contains(numbers[currentIndex]) {
            let currentNumber = numbers[currentIndex]
            
            for previousNumber in numbers[...currentIndex] {
                let sum = currentNumber + previousNumber
                knownSums.insert(sum)
            }
            
            currentIndex = numbers.index(after: currentIndex)
        }
        
        return numbers[currentIndex]
    }
    
    func part2(withInvalidNumber invalidNumber: Int, using numbers: [Int]) -> Int {
        var searchSize = 2
        
        while true {
            for startIndex in numbers.startIndex ..< (numbers.endIndex - searchSize - 1) {
                let contiguousNumbers = Array(numbers[startIndex ..< startIndex + searchSize])
                let sumOfContiguousNumber = contiguousNumbers.reduce(0, +)
                
                if sumOfContiguousNumber == invalidNumber {
                    let minimum = contiguousNumbers.min()!
                    let maximum = contiguousNumbers.max()!
                    
                    return minimum + maximum
                }
            }
            
            searchSize += 1
        }
        
        fatalError("Invalid state")
    }
}

Day9.main()
