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
        
        let part1Solution = part1(with: numbers)
        printTitle("Part 1", level: .title1)
        print("First number that does not have the property:", part1Solution, terminator: "\n\n")
    }
    
    func part1(with numbers: [Int]) -> Int {
        let preamble = numbers[0..<25]
        var knownSums: [Int: (Int, Int)] = preamble.combinations(ofCount: 2)
            .reduce(into: [:], { result, combination in
                let sum = combination.reduce(0, +)
                result[sum] = (combination[0], combination[1])
            })
        
        var currentIndex = 25
        while knownSums.keys.contains(numbers[currentIndex]) {
            let currentNumber = numbers[currentIndex]
            
            for previousNumber in numbers[...currentIndex] {
                let sum = currentNumber + previousNumber
                knownSums[sum] = (previousNumber, currentNumber)
            }
            
            currentIndex = numbers.index(after: currentIndex)
        }
        
        return numbers[currentIndex]
    }
}

Day9.main()
