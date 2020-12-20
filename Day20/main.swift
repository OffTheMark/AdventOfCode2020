//
//  main.swift
//  Day20
//
//  Created by Marc-Antoine Malépart on 2020-12-20.
//

import Foundation
import AdventOfCodeUtilities
import ArgumentParser
import Algorithms

struct Day20: DayCommand {
    @Argument(help: "Puzzle input path")
    var puzzleInputPath: String
    
    func run() throws {
        let tileRawValues = try readFile().components(separatedBy: "\n\n")
        let tiles = tileRawValues.compactMap({ Tile(rawValue: $0) })
        
        let part1Solution = part1(with: tiles)
        printTitle("Part 1", level: .title1)
        print("Product:", part1Solution)
    }
    
    func part1(with tiles: [Tile]) -> Int {
        var matchingTilesByTile = [Int: Set<Int>]()
        
        for combination in tiles.combinations(ofCount: 2) {
            let tile = combination[0]
            let otherTile = combination[1]
            
            if tile.identifier == otherTile.identifier {
                continue
            }
            
            let edgesMatch = product(tile.allEdges, otherTile.allEdges).contains(where: { edge, otherEdge in
                if edge == otherEdge {
                    return true
                }
                
                return edge == String(otherEdge.reversed())
            })
            
            if edgesMatch {
                matchingTilesByTile[tile.identifier, default: []].insert(otherTile.identifier)
                matchingTilesByTile[otherTile.identifier, default: []].insert(tile.identifier)
            }
        }
        
        return matchingTilesByTile
            .compactMap({ (identifier, matches) -> Int? in
                if matches.count == 2 {
                    return identifier
                }
                
                return nil
            })
            .reduce(1, *)
    }
}

Day20.main()
