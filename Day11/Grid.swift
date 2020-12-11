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
    
    func contains(_ coordinate: Coordinate) -> Bool {
        (0 ..< size.width).contains(coordinate.y) && (0 ..< size.height).contains(coordinate.y)
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
    
    func nextAccordingToPart2() -> Grid {
        var newGrid = self
        
        let knownOccupiedSeats = Set(variableCoordinates.filter({ contents[$0] == .occupiedSeat }))
        
        for coordinate in variableCoordinates {
            let square = contents[coordinate, default: .floor]
            let numberOfVisibleOccupiedSeats = Coordinate.allDirections.count(where: { direction in
                for multiplier in 1... {
                    let newCoordinate = coordinate + multiplier * direction
                    
                    guard self.contains(newCoordinate) else {
                        return false
                    }
                    
                    if knownOccupiedSeats.contains(newCoordinate) {
                        return true
                    }
                }
                
                return false
            })
            
            let newSquare: Square
            switch (square, numberOfVisibleOccupiedSeats) {
            case (.emptySeat, 0):
                newSquare = .occupiedSeat
                
            case (.occupiedSeat, 5...):
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
        return Self.allDirections.map({ self + $0 })
    }
    
    static let north = Coordinate(x: 0, y: -1)
    static let northEast = Coordinate(x: 1, y: -1)
    static let east = Coordinate(x: 1, y: 0)
    static let southEast = Coordinate(x: 1, y: 1)
    static let south = Coordinate(x: 0, y: 1)
    static let southWest = Coordinate(x: -1, y: 1)
    static let west = Coordinate(x: -1, y: 0)
    static let northWest = Coordinate(x: -1, y: -1)
    
    static var allDirections: [Coordinate] {
        [.north, .northEast, .east, .southEast, .south, .southWest, .west, .northWest]
    }
}

extension Coordinate: Equatable {}

extension Coordinate: Hashable {}

extension Coordinate {
    static func + (lhs: Coordinate, rhs: Coordinate) -> Coordinate {
        Coordinate(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
    
    static func * (lhs: Int, rhs: Coordinate) -> Coordinate {
        Coordinate(x: lhs * rhs.x, y: lhs & rhs.y)
    }
}
