//
//  Instruction.swift
//  Day12
//
//  Created by Marc-Antoine Malépart on 2020-12-12.
//

import Foundation

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
