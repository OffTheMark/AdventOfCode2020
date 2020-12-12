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
        print("Distance:", part1Solution, terminator: "\n\n")
        
        
    }
    
    func part1(using instructions: [Instruction]) -> Int {
        let initialPosition: Point = .zero
        var ship = Ship(position: initialPosition, direction: .east)
        
        for instruction in instructions {
            switch instruction.action {
            case .north:
                let delta = instruction.value * Direction.north.point
                ship.position += delta
                
            case .south:
                let delta = instruction.value * Direction.south.point
                ship.position += delta
                
            case .east:
                let delta = instruction.value * Direction.east.point
                ship.position += delta
            
            case .west:
                let delta = instruction.value * Direction.west.point
                ship.position += delta
                
            case .left:
                let numberOfTimes = instruction.value / 90
                ship.direction.turnLeft(numberOfTimes: numberOfTimes)
                
            case .right:
                let numberOfTimes = instruction.value / 90
                ship.direction.turnRight(numberOfTimes: numberOfTimes)
                
            case .forward:
                let delta = instruction.value * ship.direction.point
                ship.position += delta
            }
        }
        
        return ship.position.manhattanDistance(to: initialPosition)
    }
}

Day12.main()
