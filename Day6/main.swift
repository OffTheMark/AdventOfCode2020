//
//  main.swift
//  Day6
//
//  Created by Marc-Antoine Malépart on 2020-12-06.
//

import Foundation
import AdventOfCodeUtilities
import ArgumentParser

struct Day6: DayCommand {
    @Argument(help: "Puzzle input path")
    var puzzleInputPath: String
    
    func run() throws {
        let input = try readFile()
        let groups = input.components(separatedBy: "\n\n")
        
        let part1Solution = part1(with: groups)
        printTitle("Part 1", level: .title1)
        print("Sum:", part1Solution, terminator: "\n\n")
    }
    
    func part1(with groups: [String]) -> Int {
        return groups.reduce(into: 0, { count, group in
            let allAnswers = group.components(separatedBy: .newlines).joined()
            let disctinctQuestionsAnswered = Set(allAnswers)
            count += disctinctQuestionsAnswered.count
        })
    }
}

Day6.main()
