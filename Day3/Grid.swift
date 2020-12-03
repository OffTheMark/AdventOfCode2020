//
//  Grid.swift
//  Day3
//
//  Created by Marc-Antoine Malépart on 2020-12-03.
//

import Foundation
import Algorithms

struct Grid {
    let squaresByCoordinate: [Coordinate: Square]
    let width: Int
    let height: Int
    
    subscript(coordinate: Coordinate) -> Square? {
        var actualX = coordinate.x % width
        if actualX < 0 {
            actualX += width
        }
        let actualCoordinate = Coordinate(x: actualX, y: coordinate.y)
        
        return squaresByCoordinate[actualCoordinate]
    }
    
    func contains(_ coordinate: Coordinate) -> Bool {
        return coordinate.y < height
    }
}

extension Grid {
    init(lines: [String]) {
        var squaresByCoordinate = [Coordinate: Square]()
        var width = 0
        var height = 0
        
        for (lineIndex, line) in lines.enumerated() {
            for (columnIndex, character) in line.enumerated() {
                let coordinate = Coordinate(x: columnIndex, y: lineIndex)
                let square = Square(rawValue: character)
                squaresByCoordinate[coordinate] = square
                
                width = max(width, columnIndex + 1)
            }
            
            height = max(height, lineIndex + 1)
        }
        
        self.squaresByCoordinate = squaresByCoordinate
        self.width = width
        self.height = height
    }
}

enum Square: Character {
    case open = "."
    case tree = "#"
}

struct Coordinate {
    var x: Int
    var y: Int
    
    static let zero = Coordinate(x: 0, y: 0)
}

extension Coordinate: Hashable {}
