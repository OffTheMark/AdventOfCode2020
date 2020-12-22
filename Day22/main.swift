//
//  main.swift
//  Day22
//
//  Created by Marc-Antoine Malépart on 2020-12-22.
//

import Foundation
import AdventOfCodeUtilities
import ArgumentParser

struct Day22: DayCommand {
    @Argument(help: "Puzzle input path")
    var puzzleInputPath: String
    
    func run() throws {
        let state = State(rawValue: try readFile())!
        
        let part1Solution = part1(using: state)
        printTitle("Part 1", level: .title1)
        print("Score:", part1Solution, terminator: "\n\n")
        
        let part2Solution = part2(using: state)
        printTitle("Part 2", level: .title1)
        print("Score:", part2Solution)
    }
    
    func part1(using state: State) -> Int {
        var game = CombatGame(state: state)
        let winner = game.play()
        
        return winner.score()
    }
    
    func part2(using state: State) -> Int {
        var game = RecurseCombatGame(state: state)
        let winner = game.play()
        
        return winner.score()
    }
}

Day22.main()
