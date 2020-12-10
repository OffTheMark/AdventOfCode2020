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
        
        let part2Solution = part2(using: adapters)
        printTitle("Title 2", level: .title1)
        print("Count:", part2Solution)
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
    
    func part2(using adapters: [Int]) -> Int {
        let sortedAdapters = adapters.sorted()
        let allAdapters = [0] + sortedAdapters + [sortedAdapters.last!]
        
        var pathCountPerEnd: [Int: Int] = [0: 1]
        for end in allAdapters.dropFirst() {
            let predecessorOffset = 1 ... 3
            pathCountPerEnd[end] = predecessorOffset
                .reduce(into: 0, { count, offset in
                    count += pathCountPerEnd[end - offset, default: 0]
                })
        }
        
        return pathCountPerEnd[allAdapters.last!, default: 0]
    }
}

Day10.main()
