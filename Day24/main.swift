//
//  main.swift
//  Day24
//
//  Created by Marc-Antoine Malépart on 2020-12-24.
//

import Foundation
import AdventOfCodeUtilities
import ArgumentParser

struct Day24: DayCommand {
    @Argument(help: "Puzzle input path")
    var puzzleInputPath: String
    
    func run() throws {
        let lines = try readLines()
        
        printTitle("Part 1", level: .title1)
        let part1Solution = part1(with: lines)
        print("Count:", part1Solution)
    }
    
    func part1(with lines: [String]) -> Int {
        var tilesByPoint: [CubePoint: Tile] = [.zero: .white]
        
        for line in lines {
            var currentIndex = line.startIndex
            var directions = [Direction]()
            var vector: CubeVector = .zero
            
            while currentIndex < line.endIndex {
                if currentIndex != line.indices.last {
                    let rawValue = String(line[currentIndex ... line.index(after: currentIndex)])
                    
                    if let direction = Direction(rawValue: rawValue) {
                        vector += direction.vector
                        directions.append(direction)
                        
                        currentIndex = line.index(currentIndex, offsetBy: 2)
                        continue
                    }
                }
                
                let rawValue = String(line[currentIndex])
                let direction = Direction(rawValue: rawValue)!
                directions.append(direction)
                
                vector += direction.vector
                
                currentIndex = line.index(after: currentIndex)
            }
            
            let point = CubePoint.zero + vector
            
            tilesByPoint[point, default: .white].flip()
        }
        
        return tilesByPoint.values.count(where: { $0 == .black })
    }
}

Day24.main()
