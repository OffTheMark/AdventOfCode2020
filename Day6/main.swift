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
        
        let part2Solution = part2(with: groups)
        printTitle("Part 2", level: .title1)
        print("Sum:", part2Solution)
    }
    
    func part1(with groups: [String]) -> Int {
        return groups.reduce(into: 0, { count, group in
            let allAnswers = group.components(separatedBy: .newlines).joined()
            let disctinctQuestionsAnswered = Set(allAnswers)
            count += disctinctQuestionsAnswered.count
        })
    }
    
    func part2(with groups: [String]) -> Int {
        var count = 0
        
        for group in groups {
            var answers = group.components(separatedBy: .newlines)
            
            if answers.isEmpty {
                continue
            }
            
            let firstAnswer = answers.removeFirst()
            var questionsAnsweredByEveryone = Set(firstAnswer)
            
            for answer in answers {
                let questionsAnswered = Set(answer)
                questionsAnsweredByEveryone.formIntersection(questionsAnswered)
            }
            
            count += questionsAnsweredByEveryone.count
        }
        
        return count
    }
}

Day6.main()
