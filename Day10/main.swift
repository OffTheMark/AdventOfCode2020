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
        let adapters: [Int] = try readLines().compactMap({ Int($0) }).sorted()
        let allAdapters = [0] + adapters + [adapters.last! + 3]
        
        let part1Solution = part1(using: allAdapters)
        printTitle("Title 1", level: .title1)
        print("Product:", part1Solution, terminator: "\n\n")
        
        let part2Solution = part2(using: allAdapters)
        printTitle("Title 2", level: .title1)
        print("Count:", part2Solution)
    }
    
    func part1(using adapters: [Int]) -> Int {
        var countByJoltDifference = [Int: Int]()
        
        for index in adapters.indices.dropLast() {
            let currentRating = adapters[index]
            let nextRating = adapters[index + 1]
            let difference = nextRating - currentRating
            
            countByJoltDifference[difference, default: 0] += 1
        }
        
        return countByJoltDifference[1, default: 0] * countByJoltDifference[3, default: 0]
    }
    
    func part2(using adapters: [Int]) -> Int {
        var pathCountByDestination: [Int: Int] = [0: 1]
        
        for destination in adapters.dropFirst() {
            let predecessorOffset = 1 ... 3
            pathCountByDestination[destination] = predecessorOffset
                .reduce(into: 0, { count, offset in
                    count += pathCountByDestination[destination - offset, default: 0]
                })
        }
        
        return pathCountByDestination[adapters.last!, default: 0]
    }
}

Day10.main()
