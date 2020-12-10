//
//  main.swift
//  Day10
//
//  Created by Marc-Antoine Malépart on 2020-12-10.
//

import Foundation
import AdventOfCodeUtilities
import ArgumentParser
import SwiftDataStructures

struct Day10: DayCommand {
    @Argument(help: "Puzzle input path")
    var puzzleInputPath: String
    
    func run() throws {
        let adapters: [Int] = try readLines().compactMap({ Int($0) })
        
        let part1Solution = part1(using: adapters)
        printTitle("Title 1", level: .title1)
        print("Product:", part1Solution, terminator: "\n\n")
    }
    
    func part1(using adapters: [Int]) -> Int {
        var countByJoltDifference = [Int: Int]()
        let sortedAdapters = adapters.sorted()
        let chain = [0] + sortedAdapters + [sortedAdapters.last! + 3]
        
        for index in chain.indices.dropLast() {
            let currentRating = chain[index]
            let nextRating = chain[index + 1]
            let difference = nextRating - currentRating
            
            countByJoltDifference[difference, default: 0] += 1
        }
        
        return countByJoltDifference[1, default: 0] * countByJoltDifference[3, default: 0]
    }
}

Day10.main()
