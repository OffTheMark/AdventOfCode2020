//
//  Instruction.swift
//  Day12
//
//  Created by Marc-Antoine Malépart on 2020-12-12.
//

import Foundation

struct Point {
    var x: Double
    var y: Double
    
    func manhattanDistance(to other: Point) -> Double {
        return abs(other.x - x) + abs(other.y - y)
    }
    
    mutating func rotate(by angle: Measurement<UnitAngle>) {
        let radians = angle.converted(to: .radians)
        
        let sine = sin(radians.value)
        let cosine = cos(radians.value)
        let newX = cosine * x - sine * y
        let newY = sine * x + cosine * y
        
        self.x = newX
        self.y = newY
    }
    
    static let zero = Point(x: 0, y: 0)
}

extension Point {
    static func += (lhs: inout Point, rhs: Point) {
        lhs.x += rhs.x
        lhs.y += rhs.y
    }
    
    static func * (lhs: Double, rhs: Point) -> Point {
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
    let value: Double
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
        
        guard let value = Double(rawValue) else {
            return nil
        }
        
        self.action = action
        self.value = value
    }
}
