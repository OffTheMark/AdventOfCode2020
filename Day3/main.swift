//
//  main.swift
//  Day3
//
//  Created by Marc-Antoine Malépart on 2020-12-02.
//

import Foundation
import AdventOfCodeUtilities
import ArgumentParser

struct Day3: DayCommand {
    @Argument(help: "Puzzle input path")
    var puzzleInputPath: String
    
    func run() throws {
        let lines = try readLines()
        
        let part1Solution = part1(with: lines)
        printTitle("Part 1", level: .title1)
        print("Number of trees:", part1Solution, terminator: "\n\n")
    }
    
    func part1(with lines: [String]) -> Int {
        let grid = Grid(lines: lines)
        var currentPosition = Coordinate(x: 3, y: 1)
        var countOfTrees = 0
        
        while grid.contains(currentPosition), let square = grid[currentPosition] {
            if square == .tree {
                countOfTrees += 1
            }
            
            currentPosition.x += 3
            currentPosition.y += 1
        }
        
        return countOfTrees
    }
}

Day3.main()
