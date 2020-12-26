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
    let leftEdge: Tile.Edge
    let rightTileIdentifier: Int
    let rightEdge: Tile.Edge
    
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
        print("Count:", part2Solution)
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
        let unmatchedEdgesByTile: [Int: Set<Tile.Edge>] = tiles.reduce(into: [:], { result, tile in
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
        var remainingNonCornerIdentifiers: Set<Int> = Set(tiles.map({ $0.identifier })).subtracting(remainingCornerIdentifiers)
        
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
                        let topLeftCorner = tilesByIdentifier[remainingCornerIdentifiers.first!]!
                            .allArrangements
                            .first(where: { tile in
                                let unmatchedEdges = unmatchedEdgesByTile[tile.identifier]!
                                let topAndLeftEdgesAreUnmatched = [tile.leftEdge, tile.topEdge].allSatisfy({ edge in
                                    return [edge, String(edge.reversed())].contains(where: { unmatchedEdges.contains($0) })
                                })
                                
                                return topAndLeftEdgesAreUnmatched
                            })!
                        
                        remainingCornerIdentifiers.remove(topLeftCorner.identifier)
                        gridRow.append(topLeftCorner)
                        continue
                    }
                    
                    let leftTile = gridRow.last!
                    
                    if isLastColumn {
                        let remainingCorners = remainingCornerIdentifiers.map({ tilesByIdentifier[$0]! })
                        
                        let topRightCorner = remainingCorners
                            .flatMap({ $0.allArrangements })
                            .first(where: { tile in
                                let unmatchedEges = unmatchedEdgesByTile[tile.identifier]!
                                let topAndRightEdgesAreUnmatched = [tile.topEdge, tile.rightEdge].allSatisfy({ edge in
                                    return [edge, String(edge.reversed())].contains(where: { unmatchedEges.contains($0) })
                                })
                                
                                guard topAndRightEdgesAreUnmatched else {
                                    return false
                                }
                                
                                let leftEdgeMatches = tile.leftEdge == leftTile.rightEdge
                                return leftEdgeMatches
                            })!
                        
                        gridRow.append(topRightCorner)
                        remainingCornerIdentifiers.remove(topRightCorner.identifier)
                        continue
                    }
                    
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
                    remainingNonCornerIdentifiers.remove(correctTile.identifier)
                    continue
                }
                
                let topTile = assembledTiles.last![column]
                let topCandidateTileIdentifiers: Set<Int> = edgeMatchesByTile[topTile.identifier]!
                    .reduce(into: Set<Int>(), { result, match in
                        result.insert(match.rightTileIdentifier)
                    })
                
                if isLastRow {
                    if isFirstColumn {
                        let bottomLeftCorner = remainingCornerIdentifiers
                            .flatMap({ tilesByIdentifier[$0]!.allArrangements })
                            .first(where: { tile in
                                let unmatchedEdges = unmatchedEdgesByTile[tile.identifier]!
                                let leftAndBottomEdgesAreUnmatched = [tile.leftEdge, tile.bottomEdge].allSatisfy({ edge in
                                    return [edge, String(edge.reversed())].contains(where: { unmatchedEdges.contains($0) })
                                })
                                
                                guard leftAndBottomEdgesAreUnmatched else {
                                    return false
                                }
                                
                                let topEdgeIsCorrect = tile.topEdge == topTile.bottomEdge
                                return topEdgeIsCorrect
                            })!
                        
                        remainingCornerIdentifiers.remove(bottomLeftCorner.identifier)
                        remainingNonCornerIdentifiers.remove(bottomLeftCorner.identifier)
                        gridRow.append(bottomLeftCorner)
                        continue
                    }
                    
                    let leftTile = gridRow.last!
                    let leftCandidateTileIdentifiers: Set<Int> = edgeMatchesByTile[leftTile.identifier]!
                        .reduce(into: Set<Int>(), { result, match in
                            result.insert(match.rightTileIdentifier)
                        })
                    let candidateTileIdentifiers = leftCandidateTileIdentifiers.intersection(topCandidateTileIdentifiers)
                    
                    if isLastColumn {
                        let bottomRightCorner = tilesByIdentifier[remainingCornerIdentifiers.first!]!
                            .allArrangements
                            .first(where: { tile in
                                let unmatchedEdges = unmatchedEdgesByTile[tile.identifier]!
                                let rightAndBottomEdgesAreUnmatched = [tile.rightEdge, tile.bottomEdge].allSatisfy({ edge in
                                    return [edge, String(edge.reversed())].contains(where: { unmatchedEdges.contains($0) })
                                })
                                
                                guard rightAndBottomEdgesAreUnmatched else {
                                    return false
                                }
                                
                                let leftEdgeIsCorrect = tile.leftEdge == leftTile.rightEdge
                                
                                guard leftEdgeIsCorrect else {
                                    return false
                                }
                                
                                let topEdgeIsCorrect = tile.topEdge == topTile.bottomEdge
                                return topEdgeIsCorrect
                            })!
                        
                        remainingCornerIdentifiers.remove(bottomRightCorner.identifier)
                        gridRow.append(bottomRightCorner)
                        continue
                    }
                    
                    let correctTile = candidateTileIdentifiers
                        .flatMap({ tilesByIdentifier[$0]!.allArrangements })
                        .first(where: { tile in
                            let unmatchedEdges = unmatchedEdgesByTile[tile.identifier]!
                            
                            let bottomEdgeIsUnmatched = [tile.bottomEdge, String(tile.bottomEdge.reversed())].contains(where: { unmatchedEdges.contains($0) })
                            
                            guard bottomEdgeIsUnmatched else {
                                return false
                            }
                            
                            let leftEdgeIsCorrect = tile.leftEdge == leftTile.rightEdge
                            
                            guard leftEdgeIsCorrect else {
                                return false
                            }
                            
                            let topEdgeIsCorrect = tile.topEdge == topTile.bottomEdge
                            return topEdgeIsCorrect
                        })!
                    remainingNonCornerIdentifiers.remove(correctTile.identifier)
                    gridRow.append(correctTile)
                    
                    continue
                }
                
                if isFirstColumn {
                    let candidateTiles: [Tile] = edgeMatchesByTile[topTile.identifier]!.compactMap({ match in
                        guard remainingNonCornerIdentifiers.contains(match.rightTileIdentifier) else {
                            return nil
                        }
                        
                        return tilesByIdentifier[match.rightTileIdentifier]!
                    })
                    let correctTile = candidateTiles
                        .flatMap({ $0.allArrangements })
                        .first(where: { tile in
                            let unmatchedEdges = unmatchedEdgesByTile[tile.identifier]!
                            
                            let leftEdgeIsUnmatched = [tile.leftEdge, String(tile.leftEdge.reversed())].contains(where: { unmatchedEdges.contains($0) })
                            
                            guard leftEdgeIsUnmatched else {
                                return false
                            }
                            
                            let topEdgeIsCorrect = tile.topEdge == topTile.bottomEdge
                            return topEdgeIsCorrect
                        })!
                    
                    remainingNonCornerIdentifiers.remove(correctTile.identifier)
                    gridRow.append(correctTile)
                    continue
                }
                
                let leftTile = gridRow.last!
                let leftCandidateTileIdentifiers: Set<Int> = edgeMatchesByTile[leftTile.identifier]!
                    .reduce(into: Set<Int>(), { result, match in
                        result.insert(match.rightTileIdentifier)
                    })
                let candidateTileIdentifiers = leftCandidateTileIdentifiers.intersection(topCandidateTileIdentifiers)
                
                if isLastRow {
                    let correctTile = candidateTileIdentifiers
                        .flatMap({ tilesByIdentifier[$0]!.allArrangements })
                        .first(where: { tile in
                            let unmatchedEdges = unmatchedEdgesByTile[tile.identifier]!
                            
                            let leftEdgeIsUnmatched = [tile.leftEdge, String(tile.leftEdge.reversed())].contains(where: { unmatchedEdges.contains($0) })
                            
                            guard leftEdgeIsUnmatched else {
                                return false
                            }
                            
                            let topEdgeIsCorrect = tile.topEdge == topTile.bottomEdge
                            return topEdgeIsCorrect
                        })!
                    
                    remainingNonCornerIdentifiers.remove(correctTile.identifier)
                    gridRow.append(correctTile)
                    continue
                }
                
                let correctTile = candidateTileIdentifiers
                    .flatMap({ tilesByIdentifier[$0]!.allArrangements })
                    .first(where: { tile in
                        let topEdgeIsCorrect = tile.topEdge == topTile.bottomEdge
                        return topEdgeIsCorrect
                    })!
                remainingNonCornerIdentifiers.remove(correctTile.identifier)
                gridRow.append(correctTile)
                continue
            }
            
            assembledTiles.append(gridRow)
        }
        
        assembledTiles = assembledTiles.map({ line in
            return line.map({ $0.removingBorder() })
        })
        
        let grid = Grid(assembledTiles: assembledTiles)
        let mask = MonsterMask()
        
        for arrangement in grid.allArrangements {
            var matchingMasks = [MonsterMask]()
            
            for row in 0 ... Int(arrangement.size.height - mask.size.height) {
                for column in 0 ... Int(arrangement.size.width - mask.size.width) {
                    let transform = AffineTransform.translation(x: column, y: row)
                    let movedMask = mask.applying(transform)
                    
                    if arrangement.matches(movedMask) {
                        matchingMasks.append(movedMask)
                    }
                }
            }
            
            if matchingMasks.isEmpty == false {
                let pointsOfMonsters: Set<Point> = matchingMasks.reduce(into: [], { result, mask in
                    result.formUnion(mask.points)
                })
                
                return arrangement.contents.count(where: { point, character in
                    guard pointsOfMonsters.contains(point) == false else {
                        return false
                    }
                    
                    return character == "#"
                })
            }
        }
        
        return 0
    }
}

Day20.main()
