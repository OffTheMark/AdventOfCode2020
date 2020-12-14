//
//  main.swift
//  Day14
//
//  Created by Marc-Antoine Malépart on 2020-12-14.
//

import Foundation
import AdventOfCodeUtilities
import ArgumentParser

struct Day14: DayCommand {
    @Argument(help: "Puzzle input path")
    var puzzleInputPath: String
    
    func run() throws {
        let lines = try readLines()
        
        let part1Solution = part1(with: lines)
        printTitle("Part 1", level: .title1)
        print("Sum:", part1Solution, terminator: "\n\n")
        
        let part2Solution = part2(with: lines)
        printTitle("Part 2", level: .title1)
        print("Sum:", part2Solution)
    }
    
    func part1(with lines: [String]) -> Int {
        let lines = lines.compactMap({ Version1.Line(rawValue: $0) })
        
        var memory = [Int: Int]()
        var currentMask: [Int: Version1.BitOperation]?
        
        for line in lines {
            switch line {
            case .mask(let mask):
                currentMask = mask
                
            case .write(let address, let value):
                guard let currentMask = currentMask else {
                    continue
                }
                
                let finalValue = currentMask.apply(to: value)
                memory[address] = finalValue
            }
        }
        
        return memory.values.reduce(0, +)
    }
    
    func part2(with lines: [String]) -> Int {
        let lines = lines.compactMap({ Version2.Line(rawValue: $0) })
        
        var memory = [Int: Int]()
        var currentMask: [Int: Version2.BitOperation]?
        
        for line in lines {
            switch line {
            case .mask(let mask):
                currentMask = mask
                
            case .write(let address, let value):
                guard let currentMask = currentMask else {
                    continue
                }
                
                let addresses = currentMask.addresses(from: address)
                
                for address in addresses {
                    memory[address] = value
                }
            }
        }
        
        return memory.values.reduce(0, +)
    }
}

Day14.main()
