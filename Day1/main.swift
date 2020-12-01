//
//  main.swift
//  Day1
//
//  Created by Marc-Antoine Malépart on 2020-11-26.
//

import Foundation
import AdventOfCodeUtilities
import ArgumentParser
import Algorithms

struct Day1: DayCommand {
    @Argument(help: "Puzzle input path")
    var puzzleInputPath: String
    
    func run() throws {
        let numbers = try readLines().compactMap({ Int($0) })
        
        let part1Solution = part1(with: numbers)
        printTitle("Part 1", level: .title1)
        print("Product:", part1Solution, terminator: "\n\n")
    }
    
    func part1(with numbers: [Int]) -> Int {
        let combinationsOf2 = numbers.combinations(ofCount: 2)
        let correctCombination = combinationsOf2.first(where: { combination in
            return combination.reduce(0, +) == 2020
        })!
        
        return correctCombination.reduce(into: 1, { product, number in
            product *= number
        })
    }
}

Day1.main()
