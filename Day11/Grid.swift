//
//  Grid.swift
//  Day11
//
//  Created by Marc-Antoine Malépart on 2020-12-11.
//

import Foundation

struct Grid {
    private(set) var contents: [Coordinate: Square]
    let size: Size
    let variableCoordinates: Set<Coordinate>
    
    init(lines: [String]) {
        var contents = [Coordinate: Square]()
        var variableCoordinates = Set<Coordinate>()
        let height = lines.count
        var width = 0
        
        for (line, elements) in lines.enumerated() {
            width = max(width, elements.count)
            
            for (column, character) in elements.enumerated() {
                let coordinate = Coordinate(x: column, y: line)
                guard let square = Square(rawValue: character) else {
                    continue
                }
                
                switch square {
                case .emptySeat, .occupiedSeat:
                    variableCoordinates.insert(coordinate)
                    
                case .floor:
                    break
                }
                
                contents[coordinate] = square
            }
        }
        
        self.size = Size(width: width, height: height)
        self.contents = contents
        self.variableCoordinates = variableCoordinates
    }
    
    func nextAccordingToPart1() -> Grid {
        var newGrid = self
        
        for coordinate in variableCoordinates {
            let square = contents[coordinate, default: .floor]
            let numberOfAdjacentOccupiedSeats = coordinate.adjacentCoordinates
                .count(where: { adjacentCoordinate in
                    contents[adjacentCoordinate] == .occupiedSeat
                })
            
            let newSquare: Square
            switch (square, numberOfAdjacentOccupiedSeats) {
            case (.emptySeat, 0):
                newSquare = .occupiedSeat
                
            case (.occupiedSeat, 4...):
                newSquare = .emptySeat
                
            default:
                newSquare = square
            }
            
            newGrid.contents[coordinate] = newSquare
        }
        
        return newGrid
    }
}

extension Grid: Equatable {}

enum Square: Character {
    case floor = "."
    case emptySeat = "L"
    case occupiedSeat = "#"
}

struct Size {
    var width: Int
    var height: Int
}

extension Size: Equatable {}

struct Coordinate {
    var x: Int
    var y: Int
    
    var adjacentCoordinates: [Coordinate] {
        return Direction.allDirections.map({ self + $0 })
    }
}

extension Coordinate: Equatable {}

extension Coordinate: Hashable {}

extension Coordinate {
    static func + (lhs: Coordinate, rhs: Direction) -> Coordinate {
        return Coordinate(x: lhs.x + rhs.deltaX, y: lhs.y + rhs.deltaY)
    }
}

struct Direction {
    let deltaX: Int
    let deltaY: Int
    
    private init(deltaX: Int, deltaY: Int) {
        self.deltaX = deltaX
        self.deltaY = deltaY
    }
    
    static let north = Direction(deltaX: 0, deltaY: -1)
    static let northEast = Direction(deltaX: 1, deltaY: -1)
    static let east = Direction(deltaX: 1, deltaY: 0)
    static let southEast = Direction(deltaX: 1, deltaY: 1)
    static let south = Direction(deltaX: 0, deltaY: 1)
    static let southWest = Direction(deltaX: -1, deltaY: 1)
    static let west = Direction(deltaX: -1, deltaY: 0)
    static let northWest = Direction(deltaX: -1, deltaY: -1)
    
    static var allDirections: [Direction] {
        [.north, .northEast, .east, .southEast, .south, .southWest, .west, .northWest]
    }
}
