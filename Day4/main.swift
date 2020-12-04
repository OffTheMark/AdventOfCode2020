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
        
        let part1Solution = part1(with: rawString)
        printTitle("Part1", level: .title1)
        print("Count:", part1Solution, terminator: "\n\n")
    }
    
    func part1(with rawString: String) -> Int {
        let passportLines = rawString.components(separatedBy: "\n\n")
        let requiredFields: Set<Field> = [.birthYear, .issueYear, .expirationYear, .height, .hairColor, .eyeColor, .passportID]
        
        return passportLines.reduce(into: 0, { count, line in
            let passport = Passport(rawValue: line)
            
            if requiredFields.allSatisfy({ passport.hasField($0) }) {
                count += 1
            }
        })
    }
    
}

Day4.main()
