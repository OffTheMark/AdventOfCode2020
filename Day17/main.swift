//
//  main.swift
//  Day17
//
//  Created by Marc-Antoine Malépart on 2020-12-17.
//

import Foundation
import AdventOfCodeUtilities
import ArgumentParser
import Algorithms

struct Day17: DayCommand {
    @Argument(help: "Puzzle input path")
    var puzzleInputPath: String
    
    func run() throws {
        let lines = try readLines()
        
        let part1Solution = part1(using: lines)
        printTitle("Part 1", level: .title1)
        print("Number of active cubes:", part1Solution, terminator: "\n\n")
    }
    
    func part1(using lines: [String]) -> Int {
        var grid = Grid3D(lines: lines)
        
        for _ in 0 ..< 6 {
            var copy = grid
            var rangeOfX = -1 ... 1
            var rangeOfY = -1 ... 1
            var rangeOfZ = -1 ... 1
            
            for coordinate in grid.contents.keys {
                rangeOfX = min(rangeOfX.lowerBound, coordinate.x - 1) ... max(rangeOfX.upperBound, coordinate.x + 1)
                rangeOfY = min(rangeOfY.lowerBound, coordinate.y - 1) ... max(rangeOfY.upperBound, coordinate.y + 1)
                rangeOfZ = min(rangeOfZ.lowerBound, coordinate.z - 1) ... max(rangeOfZ.upperBound, coordinate.z + 1)
            }
            
            for (pair, z) in product(product(rangeOfX, rangeOfY), rangeOfZ) {
                let (x, y) = pair
                let point = Point3D(x: x, y: y, z: z)
                let cube = grid[point]
                let numberOfActiveNeighbors = point.neighbors().count(where: { neighbor in
                    return grid[neighbor] == .active
                })
                
                switch (cube, numberOfActiveNeighbors) {
                case (.active, 2 ... 3):
                    break
                    
                case (.active, _):
                    copy[point] = .inactive
                    
                case (.inactive, 3):
                    copy[point] = .active
                    
                case (.inactive, _):
                    break
                }
            }
            
            grid.merge(copy)
        }
        
        return grid.contents.count(where: { _, cube in
            return cube == .active
        })
    }
}

Day17.main()
