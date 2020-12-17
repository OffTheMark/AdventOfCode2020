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
        
        let part2Solution = part2(using: lines)
        printTitle("Part 2", level: .title1)
        print("Number of active cubes:", part2Solution)
    }
    
    func part1(using lines: [String]) -> Int {
        var grid = Grid3D(lines: lines)
        
        var rangeOfX = -1 ... 1
        var rangeOfY = -1 ... 1
        var rangeOfZ = -1 ... 1
        
        for coordinate in grid.contents.keys {
            rangeOfX = min(rangeOfX.lowerBound, coordinate.x - 1) ... max(rangeOfX.upperBound, coordinate.x + 1)
            rangeOfY = min(rangeOfY.lowerBound, coordinate.y - 1) ... max(rangeOfY.upperBound, coordinate.y + 1)
            rangeOfZ = min(rangeOfZ.lowerBound, coordinate.z - 1) ... max(rangeOfZ.upperBound, coordinate.z + 1)
        }
        
        for _ in 0 ..< 6 {
            var copy = grid
            
            for element in product(product(rangeOfX, rangeOfY), rangeOfZ) {
                let ((x, y), z) = element
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
            
            rangeOfX = rangeOfX.lowerBound - 1 ... rangeOfX.upperBound + 1
            rangeOfY = rangeOfY.lowerBound - 1 ... rangeOfY.upperBound + 1
            rangeOfZ = rangeOfZ.lowerBound - 1 ... rangeOfZ.upperBound + 1
        }
        
        return grid.contents.count(where: { _, cube in
            return cube == .active
        })
    }
    
    func part2(using lines: [String]) -> Int {
        var grid = Grid4D(lines: lines)
        
        var rangeOfX = -1 ... 1
        var rangeOfY = -1 ... 1
        var rangeOfZ = -1 ... 1
        var rangeOfW = -1 ... 1
        
        for coordinate in grid.contents.keys {
            rangeOfX = min(rangeOfX.lowerBound, coordinate.x - 1) ... max(rangeOfX.upperBound, coordinate.x + 1)
            rangeOfY = min(rangeOfY.lowerBound, coordinate.y - 1) ... max(rangeOfY.upperBound, coordinate.y + 1)
            rangeOfZ = min(rangeOfZ.lowerBound, coordinate.z - 1) ... max(rangeOfZ.upperBound, coordinate.z + 1)
            rangeOfW = min(rangeOfW.lowerBound, coordinate.w - 1) ... max(rangeOfW.upperBound, coordinate.w + 1)
        }
        
        for _ in 0 ..< 6 {
            var copy = grid
            
            for element in product(product(product(rangeOfX, rangeOfY), rangeOfZ), rangeOfW) {
                let (((x, y), z), w) = element
                let point = Point4D(x: x, y: y, z: z, w: w)
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
            
            rangeOfX = rangeOfX.lowerBound - 1 ... rangeOfX.upperBound + 1
            rangeOfY = rangeOfY.lowerBound - 1 ... rangeOfY.upperBound + 1
            rangeOfZ = rangeOfZ.lowerBound - 1 ... rangeOfZ.upperBound + 1
            rangeOfW = rangeOfW.lowerBound - 1 ... rangeOfW.upperBound + 1
        }
        
        return grid.contents.count(where: { _, cube in
            return cube == .active
        })
    }
}

Day17.main()
