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
        let grid = Grid(lines: lines)
        
        let part1Solution = part1(with: grid)
        printTitle("Part 1", level: .title1)
        print("Number of trees:", part1Solution, terminator: "\n\n")
        
        let part2Solution = part2(with: grid)
        printTitle("Part 2", level: .title1)
        print("Product of number of trees:", part2Solution)
    }
    
    func part1(with grid: Grid) -> Int {
        let slope =  Coordinate(x: 3, y: 1)
        var currentPosition = slope
        var countOfTrees = 0
        
        while grid.contains(currentPosition), let square = grid[currentPosition] {
            if square == .tree {
                countOfTrees += 1
            }
            
            currentPosition += slope
        }
        
        return countOfTrees
    }
    
    func part2(with grid: Grid) -> Int {
        let slopes = [
            Coordinate(x: 1, y: 1),
            Coordinate(x: 3, y: 1),
            Coordinate(x: 5, y: 1),
            Coordinate(x: 7, y: 1),
            Coordinate(x: 1, y: 2)
        ]
        
        return slopes.reduce(into: 1, { product, slope in
            var currentPosition = slope
            var countOfTrees = 0
            
            while grid.contains(currentPosition), let square = grid[currentPosition] {
                if square == .tree {
                    countOfTrees += 1
                }
                
                currentPosition += slope
            }
            
            product *= countOfTrees
        })
    }
}

Day3.main()
