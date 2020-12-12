//
//  Instruction.swift
//  Day12
//
//  Created by Marc-Antoine Malépart on 2020-12-12.
//

import Foundation
import CoreGraphics

extension CGPoint {
    func manhattanDistance(to other: CGPoint) -> CGFloat {
        abs(other.y - y) + abs(other.x - x)
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
    let value: CGFloat
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
        
        guard let value = Float(rawValue) else {
            return nil
        }
        
        self.action = action
        self.value = CGFloat(value)
    }
}
