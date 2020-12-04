//
//  main.swift
//  Day4
//
//  Created by Marc-Antoine Malépart on 2020-12-04.
//

import Foundation
import AdventOfCodeUtilities
import ArgumentParser

struct Day4: DayCommand {
    @Argument(help: "Puzzle input path")
    var puzzleInputPath: String
    
    func run() throws {
        let rawString = try readFile()
        let passports = rawString
            .components(separatedBy: "\n\n")
            .map({ Passport(rawValue: $0) })
        
        let part1Solution = part1(with: passports)
        printTitle("Part1", level: .title1)
        print("Count:", part1Solution, terminator: "\n\n")
        
        let part2Solution = part2(with: passports)
        printTitle("Part2", level: .title1)
        print("Count:", part2Solution)
    }
    
    func part1(with passports: [Passport]) -> Int {
        passports.count(where: { $0.hasAllRequiredFields })
    }
    
    func part2(with passports: [Passport]) -> Int {
        passports.count(where: { $0.hasAllValidFields })
    }
    
}

Day4.main()
