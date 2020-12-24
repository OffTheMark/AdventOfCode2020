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
        let blackTiles = part1(with: lines)
        let part1Solution = blackTiles.count
        print("Count:", part1Solution, terminator: "\n\n")
        
        printTitle("Part2", level: .title1)
        let part2Solution = part2(with: blackTiles)
        print("Count:", part2Solution)
    }
    
    func part1(with lines: [String]) -> Set<CubePoint> {
        var blackTiles = Set<CubePoint>()
        
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
            
            if blackTiles.contains(point) {
                blackTiles.remove(point)
            }
            else {
                blackTiles.insert(point)
            }
        }
        
        return blackTiles
    }
    
    func part2(with blackTiles: Set<CubePoint>) -> Int {
        var blackTiles = blackTiles
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        
        for turn in 0 ..< 100 {
            print("Progress:", formatter.string(from: NSNumber(value: Float(turn) / 100))!)
            
            let pointsThatCanChange: Set<CubePoint> = blackTiles.reduce(into: [], { result, point in
                result.insert(point)
                result.formUnion(point.neighbors)
            })
            
            var addedBlackTiles = Set<CubePoint>()
            var removedBlackTiles = Set<CubePoint>()
            
            for point in pointsThatCanChange {
                let numberOfAdjacentBlackTiles = point.neighbors
                    .count(where: { neighbor in
                        blackTiles.contains(neighbor)
                    })
                
                switch (blackTiles.contains(point), numberOfAdjacentBlackTiles) {
                case (true, 0), (true, 3...):
                    removedBlackTiles.insert(point)
                    
                case (false, 2):
                    addedBlackTiles.insert(point)
                    
                default:
                    break
                }
            }
            
            blackTiles.formSymmetricDifference(removedBlackTiles)
            blackTiles.formUnion(addedBlackTiles)
            
            print("Number of black tiles:", blackTiles.count)
        }
        
        printTitle("Progress: \(formatter.string(from: 1)!)", level: .title2)
        
        return blackTiles.count
    }
}

Day24.main()
