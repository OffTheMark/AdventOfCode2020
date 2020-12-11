//
//  main.swift
//  Day11
//
//  Created by Marc-Antoine Malépart on 2020-12-11.
//

import Foundation
import AdventOfCodeUtilities
import ArgumentParser

struct Day11: DayCommand {
    @Argument(help: "Puzzle input path")
    var puzzleInputPath: String
    
    func run() throws {
        let lines = try readLines()
        let grid = Grid(lines: lines)
        
        let part1Solution = part1(with: grid)
        printTitle("Part 1", level: .title1)
        print("Number of occupied seats:", part1Solution, terminator: "\n\n")
    }
    
    func part1(with grid: Grid) -> Int {
        var previous = grid
        var current = grid.next()
        
        while previous != current {
            let next = current.next()
            previous = current
            current = next
        }
        
        return current.contents.count(where: { coordinate, square in
            return square == .occupiedSeat
        })
    }
}

Day11.main()
