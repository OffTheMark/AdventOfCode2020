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
        (0 ..< size.width).contains(coordinate.x) && (0 ..< size.height).contains(coordinate.y)
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
        
        let squareByVariableCoordinate: [Coordinate: Square] = variableCoordinates
            .reduce(into: [:], { result, coordinate in
                result[coordinate] = contents[coordinate]
            })
        
        for (coordinate, square) in squareByVariableCoordinate {
            let numberOfVisibleOccupiedSeats = Vector.allAdjacentVectors.count(where: { vector in
                let direction = vector.direction
                
                let targetsAndVectors: [(target: Coordinate, vector: Vector)] = variableCoordinates
                    .subtracting([coordinate])
                    .compactMap({ target in
                        let vector = coordinate.vector(to: target)
                        let vectorDirection = vector.direction
                        guard vectorDirection.sign == direction.sign, vectorDirection.magnitude == direction.magnitude else {
                            return nil
                        }
                        
                        return (target, vector)
                    })
                let closestOrNil = targetsAndVectors.min(by: { (first, second) in
                    return first.vector.norm < second.vector.norm
                })
                
                guard let closest = closestOrNil else {
                    return false
                }
                
                return squareByVariableCoordinate[closest.target] == .occupiedSeat
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
        return Vector.allAdjacentVectors.map({ self + $0 })
    }
    
    func vector(to other: Coordinate) -> Vector {
        Vector(x: other.x - x, y: other.y - y)
    }
}

extension Coordinate: Equatable {}

extension Coordinate: Hashable {}

extension Coordinate {
    static func + (lhs: Coordinate, rhs: Vector) -> Coordinate {
        Coordinate(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
    
    static func * (lhs: Int, rhs: Coordinate) -> Coordinate {
        Coordinate(x: lhs * rhs.x, y: lhs & rhs.y)
    }
}

struct Vector {
    var x: Int
    var y: Int
    
    var norm: Double {
        sqrt(pow(Double(y), 2) + pow(Double(x), 2))
    }
    
    var direction: Double {
        atan(Double(y) / Double(x))
    }
    
    static let north = Vector(x: 0, y: -1)
    static let northEast = Vector(x: 1, y: -1)
    static let east = Vector(x: 1, y: 0)
    static let southEast = Vector(x: 1, y: 1)
    static let south = Vector(x: 0, y: 1)
    static let southWest = Vector(x: -1, y: 1)
    static let west = Vector(x: -1, y: 0)
    static let northWest = Vector(x: -1, y: -1)
    
    static var allAdjacentVectors: [Vector] {
        [.north, .northEast, .east, .southEast, .south, .southWest, .west, .northWest]
    }
}

extension Vector {
    static func * (lhs: Int, rhs: Vector) -> Vector {
        Vector(x: lhs * rhs.x, y: lhs & rhs.y)
    }
}
