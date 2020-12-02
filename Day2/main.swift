//
//  main.swift
//  Day2
//
//  Created by Marc-Antoine Malépart on 2020-12-01.
//

import Foundation
import AdventOfCodeUtilities
import ArgumentParser

struct Day2: DayCommand {
    @Argument(help: "Puzzle input path")
    var puzzleInputPath: String
    
    func run() throws {
        let lines = try readLines()
        let firstEntries = lines.compactMap({ FirstPasswordPolicy(rawValue: $0) })
        
        let part1Solution = part1(with: firstEntries)
        printTitle("Part 1", level: .title1)
        print("Count:", part1Solution, terminator: "\n\n")
        
        let officialEntries = lines.compactMap({ OfficialPasswordPolicy(rawValue: $0) })
        
        let part2Solution = part2(with: officialEntries)
        printTitle("Part 2", level: .title1)
        print("Count:", part2Solution)
    }
    
    func part1(with entries: [FirstPasswordPolicy]) -> Int {
        return entries.count(where: { $0.isValid })
    }
    
    func part2(with entries: [OfficialPasswordPolicy]) -> Int {
        return entries.count(where: { $0.isValid })
    }
}

Day2.main()
