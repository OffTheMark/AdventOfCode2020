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
        let tilesByPoint = part1(with: lines)
        let part1Solution = tilesByPoint.count(where: { _, tile in tile == .black })
        print("Count:", part1Solution, terminator: "\n\n")
        
        printTitle("Part2", level: .title1)
        let part2Solution = part2(with: tilesByPoint)
        print("Count:", part2Solution)
    }
    
    func part1(with lines: [String]) -> [CubePoint: Tile] {
        var tilesByPoint: [CubePoint: Tile] = [.zero: .white]
        
        for line in lines {
            var currentIndex = line.startIndex
            var vector: CubeVector = .zero
            
            while currentIndex < line.endIndex {
                if currentIndex != line.indices.last {
                    let rawValue = String(line[currentIndex ... line.index(after: currentIndex)])
                    
                    if let direction = Direction(rawValue: rawValue) {
                        vector += direction.vector
                        
                        currentIndex = line.index(currentIndex, offsetBy: 2)
                        continue
                    }
                }
                
                let rawValue = String(line[currentIndex])
                let direction = Direction(rawValue: rawValue)!
                
                vector += direction.vector
                
                currentIndex = line.index(after: currentIndex)
            }
            
            let point = CubePoint.zero + vector
            
            tilesByPoint[point, default: .white].flip()
        }
        
        return tilesByPoint
    }
    
    func part2(with tilesByPoint: [CubePoint: Tile]) -> Int {
        var tilesByPoint = tilesByPoint
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        
        for turn in 0 ..< 100 {
            print("Progress:", formatter.string(from: NSNumber(value: Float(turn) / 100))!)
            
            let pointsThatCanChange: Set<CubePoint> = tilesByPoint.keys
                .reduce(into: [], { result, point in
                    guard tilesByPoint[point] == .black else {
                        return
                    }
                    
                    result.insert(point)
                    result.formUnion(point.neighbors)
                })
            
            var diff = [CubePoint: Tile]()
            
            for point in pointsThatCanChange {
                let tile = tilesByPoint[point, default: .white]
                let numberOfAdjacentBlackTiles = point.neighbors
                    .count(where: { neighbor in
                        tilesByPoint[neighbor, default: .white] == .black
                    })
                
                switch (tile, numberOfAdjacentBlackTiles) {
                case (.black, 0), (.black, 3...):
                    diff[point] = .white
                    
                case (.white, 2):
                    diff[point] = .black
                    
                default:
                    diff[point] = tile
                }
            }
            
            tilesByPoint.merge(diff, uniquingKeysWith: { _, newest in newest })
            print("Number of black tiles:", tilesByPoint.count(where: { _, tile in tile == .black }))
        }
        
        printTitle("Progress: \(formatter.string(from: 1)!)", level: .title2)
        
        return tilesByPoint.count(where: { _, tile in tile == .black })
    }
}

Day24.main()
