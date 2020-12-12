//
//  main.swift
//  Day12
//
//  Created by Marc-Antoine Malépart on 2020-12-12.
//

import Foundation
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
        var direction: Direction = .east
        
        for instruction in instructions {
            switch instruction.action {
            case .north:
                let delta = instruction.value * Direction.north.point
                position += delta
                
            case .south:
                let delta = instruction.value * Direction.south.point
                position += delta
                
            case .east:
                let delta = instruction.value * Direction.east.point
                position += delta
            
            case .west:
                let delta = instruction.value * Direction.west.point
                position += delta
                
            case .left:
                let numberOfTimes = Int(instruction.value) / 90
                direction.turnLeft(numberOfTimes: numberOfTimes)
                
            case .right:
                let numberOfTimes = Int(instruction.value) / 90
                direction.turnRight(numberOfTimes: numberOfTimes)
                
            case .forward:
                let delta = instruction.value * direction.point
                position += delta
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
                waypointPosition.y -= instruction.value
                
            case .south:
                waypointPosition.y += instruction.value
                
            case .east:
                waypointPosition.x += instruction.value
                
            case .west:
                waypointPosition.x -= instruction.value
                
            case .forward:
                position += instruction.value * waypointPosition
                
            case .left:
                waypointPosition.rotate(by: -instruction.value)
                
            case .right:
                waypointPosition.rotate(by: instruction.value)
            }
        }
        
        return position.manhattanDistance(to: initialPosition)
    }
}

Day12.main()
