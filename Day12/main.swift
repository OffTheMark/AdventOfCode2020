//
//  main.swift
//  Day12
//
//  Created by Marc-Antoine Malépart on 2020-12-12.
//

import Foundation
import CoreGraphics
import AdventOfCodeUtilities
import ArgumentParser

struct Day12: DayCommand {
    @Argument(help: "Puzzle input path")
    var puzzleInputPath: String
    
    func run() throws {
        let instructions = try readLines().compactMap({ Instruction(rawValue: $0) })
        
        let part1Solution = part1(using: instructions)
        printTitle("Part 1", level: .title1)
        print("Distance:", String(format: "%.0f", part1Solution), terminator: "\n\n")
        
        let part2Solution = part2(using: instructions)
        printTitle("Part 2", level: .title1)
        print("Distance:", String(format: "%.0f", part2Solution))
    }
    
    func part1(using instructions: [Instruction]) -> Double {
        let initialPosition: Point = .zero
        var position = initialPosition
        var direction = Point(x: 1, y: 0)
        
        for instruction in instructions {
            switch instruction.action {
            case .north:
                position.apply(.translation(x: 0, y: -instruction.value))
                
            case .south:
                position.apply(.translation(x: 0, y: instruction.value))
                
            case .east:
                position.apply(.translation(x: instruction.value, y: 0))
                
            case .west:
                position.apply(.translation(x: -instruction.value, y: 0))
                
            case .left:
                let angle = Measurement<UnitAngle>(value: Double(-instruction.value), unit: .degrees)
                direction.apply(.rotation(by: angle))
                
            case .right:
                let angle = Measurement<UnitAngle>(value: Double(instruction.value), unit: .degrees)
                direction.apply(.rotation(by: angle))
                
            case .forward:
                let translation: AffineTransform = .translation(
                    x: instruction.value * direction.x,
                    y: instruction.value * direction.y
                )
                position.apply(translation)
            }
        }
        
        return position.manhattanDistance(to: initialPosition)
    }
    
    func part2(using instructions: [Instruction]) -> Double {
        let initialPosition: Point = .zero
        var position = initialPosition
        var waypointPosition = Point(x: 10, y: -1)
        
        for instruction in instructions {
            switch instruction.action {
            case .north:
                waypointPosition.apply(.translation(x: 0, y: -instruction.value))
                
            case .south:
                waypointPosition.apply(.translation(x: 0, y: instruction.value))
                
            case .east:
                waypointPosition.apply(.translation(x: instruction.value, y: 0))
                
            case .west:
                waypointPosition.apply(.translation(x: -instruction.value, y: 0))
                
            case .forward:
                let transform: AffineTransform = .translation(
                    x: instruction.value * waypointPosition.x,
                    y: instruction.value * waypointPosition.y
                )
                position.apply(transform)
                
            case .left:
                let angle = Measurement<UnitAngle>(value: Double(-instruction.value), unit: .degrees)
                waypointPosition.apply(.rotation(by: angle))
                
            case .right:
                let angle = Measurement<UnitAngle>(value: Double(instruction.value), unit: .degrees)
                waypointPosition.apply(.rotation(by: angle))
            }
        }
        
        return position.manhattanDistance(to: initialPosition)
    }
}

Day12.main()
