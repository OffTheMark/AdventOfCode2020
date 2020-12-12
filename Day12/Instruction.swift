//
//  Instruction.swift
//  Day12
//
//  Created by Marc-Antoine Malépart on 2020-12-12.
//

import Foundation

struct Ship {
    var position: Point
    var direction: Direction
}

struct Point {
    var x: Int
    var y: Int
    
    func manhattanDistance(to other: Point) -> Int {
        return abs(other.x - x) + abs(other.y - y)
    }
    
    static let zero = Point(x: 0, y: 0)
}

extension Point {
    static func += (lhs: inout Point, rhs: Point) {
        lhs.x += rhs.x
        lhs.y += rhs.y
    }
    
    static func * (lhs: Int, rhs: Point) -> Point {
        Point(x: lhs * rhs.x, y: lhs * rhs.y)
    }
}

enum Direction {
    case north
    case east
    case south
    case west
    
    var point: Point {
        switch self {
        case .north:
            return Point(x: 0, y: -1)
            
        case .east:
            return Point(x: 1, y: 0)
        
        case .south:
            return Point(x: 0, y: 1)
            
        case .west:
            return Point(x: -1, y: 0)
        }
    }
    
    mutating func turnLeft(numberOfTimes: Int = 1) {
        for _ in 0 ..< numberOfTimes {
            switch self {
            case .north:
                self = .west
                
            case .east:
                self = .north
                
            case .south:
                self = .east
                
            case .west:
                self = .south
            }
        }
    }
    
    mutating func turnRight(numberOfTimes: Int = 1) {
        for _ in 0 ..< numberOfTimes {
            switch self {
            case .north:
                self = .east
                
            case .east:
                self = .south
                
            case .south:
                self = .west
                
            case .west:
                self = .north
            }
        }
    }
}

enum Action: Character {
    case north = "N"
    case south = "S"
    case east = "E"
    case west = "W"
    case left = "L"
    case right = "R"
    case forward = "F"
}

struct Instruction {
    let action: Action
    let value: Int
}

extension Instruction {
    init?(rawValue: String) {
        guard rawValue.count >= 2 else {
            return nil
        }
        
        var rawValue = rawValue
        
        guard let action = Action(rawValue: rawValue.removeFirst()) else {
            return nil
        }
        
        guard let value = Int(rawValue) else {
            return nil
        }
        
        self.action = action
        self.value = value
    }
}
