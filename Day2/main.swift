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
        let entries = try readLines().compactMap({ PasswordEntry(rawValue: $0) })
        
        let part1Solution = part1(with: entries)
        printTitle("Part 1", level: .title1)
        print("Product:", part1Solution, terminator: "\n\n")
    }
    
    func part1(with entries: [PasswordEntry]) -> Int {
        return entries.count(where: { entry in
            let countOfCharacter = entry.password.count(of: entry.character)
            return entry.validCount.contains(countOfCharacter)
        })
    }
}

Day2.main()
