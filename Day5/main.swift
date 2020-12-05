//
//  main.swift
//  Day5
//
//  Created by Marc-Antoine Malépart on 2020-12-04.
//

import Foundation
import AdventOfCodeUtilities
import ArgumentParser

struct Day5: DayCommand {
    @Argument(help: "Puzzle input path")
    var puzzleInputPath: String
    
    func run() throws {
        let passes = try readLines().compactMap({ BoardingPass(rawValue: $0) })
        
        let part1Solution = part1(with: passes)
        printTitle("Part 1", level: .title1)
        print("Maximum identifier:", part1Solution, terminator: "\n\n")
    }
    
    func part1(with passes: [BoardingPass]) -> Int {
        return passes.reduce(into: 0, { maximumIdentifier, pass in
            let identifier = pass.identifier()
            
            maximumIdentifier = max(identifier, maximumIdentifier)
        })
    }
}

Day5.main()
