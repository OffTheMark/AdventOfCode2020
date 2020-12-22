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
    }
    
    func part1(using state: State) -> Int {
        var state = state
        
        while state.canPlayRound {
            let firstTopCard = state.first.cards.removeFirst()
            let secondTopCard = state.second.cards.removeFirst()
            
            if firstTopCard > secondTopCard {
                state.first.cards.append(contentsOf: [firstTopCard, secondTopCard])
            }
            else {
                state.second.cards.append(contentsOf: [secondTopCard, firstTopCard])
            }
        }
        
        return [state.first, state.second]
            .first(where: { $0.isEmpty == false })!
            .score()
    }
}

Day22.main()
