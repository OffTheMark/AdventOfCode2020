//
//  main.swift
//  Day5
//
//  Created by Marc-Antoine Malépart on 2020-12-04.
//

import Foundation
import AdventOfCodeUtilities
import ArgumentParser

struct Day5: DayCommand {
    @Argument(help: "Puzzle input path")
    var puzzleInputPath: String
    
    func run() throws {
        let passes = try readLines().compactMap({ BoardingPass(rawValue: $0) })
        
        let part1Solution = part1(with: passes)
        printTitle("Part 1", level: .title1)
        print("Maximum seat ID:", part1Solution, terminator: "\n\n")
        
        let part2Solution = part2(with: passes)
        printTitle("Part 2", level: .title1)
        print("Seat ID:", part2Solution)
    }
    
    func part1(with passes: [BoardingPass]) -> Int {
        return passes.max(by: { $0.seatID < $1.seatID })!.seatID
    }
    
    func part2(with passes: [BoardingPass]) -> Int {
        let identifiers = passes.map({ $0.seatID }).sorted()
        
        for (index, current) in identifiers.dropLast().enumerated() {
            let next = identifiers[index + 1]
            
            if next - current == 2 {
                return next - 1
            }
        }
        
        fatalError("Could not find seat ID")
    }
}

struct BoardingPass {
    let rawValue: String
    let seatID: Int
    
    init?(rawValue: String) {
        let binary = rawValue
            .replacingOccurrences(of: "F", with: "0")
            .replacingOccurrences(of: "B", with: "1")
            .replacingOccurrences(of: "L", with: "0")
            .replacingOccurrences(of: "R", with: "1")
        
        guard let seatID = Int(binary, radix: 2) else {
            return nil
        }
        
        self.rawValue = rawValue
        self.seatID = seatID
    }
}

Day5.main()
