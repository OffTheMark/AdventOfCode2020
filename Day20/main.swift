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

struct EdgeMatch {
    let leftTileIdentifier: Int
    let leftEdge: String
    let rightTileIdentifier: Int
    let rightEdge: String
    
    func reversed() -> EdgeMatch {
        EdgeMatch(
            leftTileIdentifier: rightTileIdentifier,
            leftEdge: rightEdge,
            rightTileIdentifier: leftTileIdentifier,
            rightEdge: leftEdge
        )
    }
}

struct Day20: DayCommand {
    @Argument(help: "Puzzle input path")
    var puzzleInputPath: String
    
    func run() throws {
        let tileRawValues = try readFile().components(separatedBy: "\n\n")
        let tiles = tileRawValues.compactMap({ Tile(rawValue: $0) })
        
        printTitle("Part 1", level: .title1)
        let edgesMatchesByTile = part1(with: tiles)
        let part1Solution = edgesMatchesByTile
            .compactMap({ (identifier, matches) -> Int? in
                if matches.count == 2 {
                    return identifier
                }
                
                return nil
            })
            .reduce(1, *)
        print("Product:", part1Solution, terminator: "\n\n")
        
        printTitle("Part 2", level: .title1)
        let part2Solution = part2(with: tiles, edgeMatchesByTile: edgesMatchesByTile)
    }
    
    func part1(with tiles: [Tile]) -> [Int: [EdgeMatch]] {
        var edgeMatchesByTile = [Int: [EdgeMatch]]()
        
        for combination in tiles.combinations(ofCount: 2) {
            let tile = combination[0]
            let otherTile = combination[1]
            
            if tile.identifier == otherTile.identifier {
                continue
            }
            
            let edgeMatches: [EdgeMatch] = product(tile.allEdges, otherTile.allEdges).compactMap({ edge, otherEdge in
                guard edge == otherEdge || edge == String(otherEdge.reversed()) else {
                    return nil
                }
                
                return EdgeMatch(
                    leftTileIdentifier: tile.identifier,
                    leftEdge: edge,
                    rightTileIdentifier: otherTile.identifier,
                    rightEdge: otherEdge
                )
            })
            
            if edgeMatches.isEmpty == false {
                edgeMatchesByTile[tile.identifier, default: []].append(contentsOf: edgeMatches)
                edgeMatchesByTile[otherTile.identifier, default: []].append(contentsOf: edgeMatches.map({ $0.reversed() }))
            }
        }
        
        return edgeMatchesByTile
    }
    
    func part2(with tiles: [Tile], edgeMatchesByTile: [Int: [EdgeMatch]]) -> Int {
        let tilesByIdentifier: [Int: Tile] = tiles.reduce(into: [:], { result, tile in
            result[tile.identifier] = tile
        })
        let unmatchedEdgesByTile: [Int: Set<String>] = tiles.reduce(into: [:], { result, tile in
            let matchedEdges = Set(edgeMatchesByTile[tile.identifier]!.map({ $0.leftEdge }))
            let unmatchedEdges = Set(tile.allEdges).subtracting(matchedEdges)
            result[tile.identifier] = unmatchedEdges
        })
        var remainingCornerIdentifiers: Set<Int> = unmatchedEdgesByTile.reduce(into: [], { result, element in
            let (identifier, edges) = element
            
            if edges.count == 2 {
                result.insert(identifier)
            }
        })
        
        let sideLength = Int(sqrt(Double(tiles.count)))
        let rows = 0 ..< sideLength
        let columns = 0 ..< sideLength
        
        var assembledTiles = [[Tile]]()
        
        for row in rows {
            var gridRow = [Tile]()
            
            for column in columns {
                let isFirstRow = row == 0
                let isLastRow = row == rows.last
                let isFirstColumn = column == 0
                let isLastColumn = column == columns.last
                
                if isFirstRow {
                    if isFirstColumn {
                        let leftCornerIdentifier = remainingCornerIdentifiers.first!
                        let leftCorner = tilesByIdentifier[leftCornerIdentifier]!
                            .allArrangements
                            .first(where: { tile in
                                let unmatchedEdges = unmatchedEdgesByTile[tile.identifier]!
                                return [tile.leftEdge, tile.topEdge].allSatisfy({ edge in
                                    return [edge, String(edge.reversed())].contains(where: { unmatchedEdges.contains($0) })
                                })
                            })!
                        
                        remainingCornerIdentifiers.remove(leftCornerIdentifier)
                        gridRow.append(leftCorner)
                        continue
                    }
                    
                    if isLastColumn {
                        let remainingCorners = remainingCornerIdentifiers.map({ tilesByIdentifier[$0]! })
                        let leftTile = gridRow.last!
                        
                        let rightCorner = remainingCorners
                            .flatMap({ $0.allArrangements })
                            .first(where: { tile in
                                let unmatchedEges = unmatchedEdgesByTile[tile.identifier]!
                                let topAndRightEdgesMatch = [tile.topEdge, tile.rightEdge].allSatisfy({ edge in
                                    return [edge, String(edge.reversed())].contains(where: { unmatchedEges.contains($0) })
                                })
                                
                                guard topAndRightEdgesMatch else {
                                    return false
                                }
                                
                                let leftEdgeMatches = tile.leftEdge == leftTile.rightEdge
                                return leftEdgeMatches
                            })!
                        
                        gridRow.append(rightCorner)
                        remainingCornerIdentifiers.remove(rightCorner.identifier)
                        continue
                    }
                    
                    let leftTile = gridRow.last!
                    
                    let correctTile = edgeMatchesByTile[leftTile.identifier]!
                        .flatMap({ tilesByIdentifier[$0.rightTileIdentifier]!.allArrangements })
                        .first(where: { tile in
                            let unmatchedEges = unmatchedEdgesByTile[tile.identifier]!
                            
                            guard unmatchedEges.count == 1 else {
                                return false
                            }
                            
                            let topEdgeMatches = [tile.topEdge, String(tile.topEdge.reversed())].contains(where: { unmatchedEges.contains($0) })
                            guard topEdgeMatches else {
                                return false
                            }
                            
                            let leftEdgeMatches = tile.leftEdge == leftTile.rightEdge
                            return leftEdgeMatches
                        })!
                    
                    gridRow.append(correctTile)
                    continue
                }
            }
            
            assembledTiles.append(gridRow)
        }
        
        
        return 0
    }
}

Day20.main()
