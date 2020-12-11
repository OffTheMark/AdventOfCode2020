//
//  Grid.swift
//  Day11
//
//  Created by Marc-Antoine Malépart on 2020-12-11.
//

import Foundation

struct Grid {
    private(set) var contents: [Point: Square]
    let size: Size
    let seats: Set<Point>
    
    init(lines: [String]) {
        var contents = [Point: Square]()
        var seats = Set<Point>()
        let height = lines.count
        var width = 0
        
        for (line, elements) in lines.enumerated() {
            width = max(width, elements.count)
            
            for (column, character) in elements.enumerated() {
                let coordinate = Point(x: column, y: line)
                guard let square = Square(rawValue: character) else {
                    continue
                }
                
                switch square {
                case .emptySeat, .occupiedSeat:
                    seats.insert(coordinate)
                    
                case .floor:
                    break
                }
                
                contents[coordinate] = square
            }
        }
        
        self.size = Size(width: width, height: height)
        self.contents = contents
        self.seats = seats
    }
    
    func contains(_ coordinate: Point) -> Bool {
        (0 ..< size.width).contains(coordinate.x) && (0 ..< size.height).contains(coordinate.y)
    }
    
    func nextAccordingToPart1() -> Grid {
        var newGrid = self
        
        for seat in seats {
            let square = contents[seat, default: .floor]
            let numberOfAdjacentOccupiedSeats = seat.adjacentPoints
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
            
            newGrid.contents[seat] = newSquare
        }
        
        return newGrid
    }
    
    func nextAccordingToPart2() -> Grid {
        var newGrid = self
        
        for seat in seats {
            let square = contents[seat, default: .floor]
            let otherSeats = seats.subtracting([seat])
            
            let numberOfVisibleOccupiedSeats = Vector.allAdjacentVectors
                .count(where: { vector in
                    for multiplier in 1... {
                        let searchPoint = seat + multiplier * vector
                        
                        if !contains(searchPoint) {
                            return false
                        }
                        
                        if otherSeats.contains(searchPoint) {
                            return contents[searchPoint] == .occupiedSeat
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

struct Point {
    var x: Int
    var y: Int
    
    var adjacentPoints: [Point] {
        return Vector.allAdjacentVectors.map({ self + $0 })
    }
    
    func vector(to other: Point) -> Vector {
        Vector(x: other.x - x, y: other.y - y)
    }
}

extension Point: Equatable {}

extension Point: Hashable {}

extension Point {
    static func + (lhs: Point, rhs: Vector) -> Point {
        Point(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
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
        Vector(x: lhs * rhs.x, y: lhs * rhs.y)
    }
}
