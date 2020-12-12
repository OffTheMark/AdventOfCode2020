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
    
    func part1(using instructions: [Instruction]) -> CGFloat {
        let initialPosition: CGPoint = .zero
        var position = initialPosition
        var direction = CGPoint(x: 1, y: 0)
        
        for instruction in instructions {
            switch instruction.action {
            case .north:
                let transform = CGAffineTransform(translationX: 0, y: -instruction.value)
                position = position.applying(transform)
                
            case .south:
                let transform = CGAffineTransform(translationX: 0, y: instruction.value)
                position = position.applying(transform)
                
            case .east:
                let transform = CGAffineTransform(translationX: instruction.value, y: 0)
                position = position.applying(transform)
                
            case .west:
                let transform = CGAffineTransform(translationX: -instruction.value, y: 0)
                position = position.applying(transform)
                
            case .left:
                var angle = Measurement<UnitAngle>(value: Double(-instruction.value), unit: .degrees)
                angle.convert(to: .radians)
                let radians = CGFloat(angle.value)
                let rotation = CGAffineTransform(rotationAngle: radians)
                
                direction = direction.applying(rotation)
                
            case .right:
                var angle = Measurement<UnitAngle>(value: Double(instruction.value), unit: .degrees)
                angle.convert(to: .radians)
                let radians = CGFloat(angle.value)
                let rotation = CGAffineTransform(rotationAngle: radians)
                
                direction = direction.applying(rotation)
                
            case .forward:
                let translation = CGAffineTransform(
                    translationX: instruction.value * direction.x,
                    y: instruction.value * direction.y
                )
                position = position.applying(translation)
            }
        }
        
        return position.manhattanDistance(to: initialPosition)
    }
    
    func part2(using instructions: [Instruction]) -> CGFloat {
        let initialPosition: CGPoint = .zero
        var position = initialPosition
        var waypointPosition = CGPoint(x: 10, y: -1)
        
        for instruction in instructions {
            switch instruction.action {
            case .north:
                let translation = CGAffineTransform(translationX: 0, y: -instruction.value)
                waypointPosition = waypointPosition.applying(translation)
                
            case .south:
                let translation = CGAffineTransform(translationX: 0, y: instruction.value)
                waypointPosition = waypointPosition.applying(translation)
                
            case .east:
                let translation = CGAffineTransform(translationX: instruction.value, y: 0)
                waypointPosition = waypointPosition.applying(translation)
                
            case .west:
                let translation = CGAffineTransform(translationX: -instruction.value, y: 0)
                waypointPosition = waypointPosition.applying(translation)
                
            case .forward:
                let transform = CGAffineTransform(
                    translationX: instruction.value * waypointPosition.x,
                    y: instruction.value * waypointPosition.y
                )
                position = position.applying(transform)
                
            case .left:
                var angle = Measurement<UnitAngle>(value: Double(-instruction.value), unit: .degrees)
                angle.convert(to: .radians)
                let radians = CGFloat(angle.value)
                let rotation = CGAffineTransform(rotationAngle: radians)
                
                waypointPosition = waypointPosition.applying(rotation)
                
            case .right:
                var angle = Measurement<UnitAngle>(value: Double(instruction.value), unit: .degrees)
                angle.convert(to: .radians)
                let radians = CGFloat(angle.value)
                let rotation = CGAffineTransform(rotationAngle: radians)
                
                waypointPosition = waypointPosition.applying(rotation)
            }
        }
        
        return position.manhattanDistance(to: initialPosition)
    }
}

Day12.main()
