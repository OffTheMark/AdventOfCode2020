//
//  main.swift
//  Day13
//
//  Created by Marc-Antoine Malépart on 2020-12-13.
//

import Foundation
import AdventOfCodeUtilities
import ArgumentParser

enum Bus {
    case inService(identifier: Int64)
    case any
}

struct Day13: DayCommand {
    @Argument(help: "Puzzle input path")
    var puzzleInputPath: String
    
    func run() throws {
        let lines = try readLines()
        let earliestDeparture = Int(lines[0])!
        let availableBuses = lines[1].components(separatedBy: ",").compactMap({ Int($0) })
        let buses: [Bus] = lines[1].components(separatedBy: ",").map({ part in
            if let identifier = Int64(part) {
                return .inService(identifier: identifier)
            }
            
            return .any
        })
        
        let part1Solution = part1(earliestDeparture: earliestDeparture, availableBuses: availableBuses)
        printTitle("Title 1", level: .title1)
        print("Result:", part1Solution, terminator: "\n\n")
        
        let part2Solution = part2(using: buses)
        printTitle("Title 2", level: .title1)
        print("Result:", part2Solution)
    }
    
    func part1(earliestDeparture: Int, availableBuses: [Int]) -> Int {
        let earliestDepartureByAvailableBus: [Int: Int] = availableBuses
            .reduce(into: [:], { result, bus in
                var earliestDepartureForBus = (earliestDeparture / bus) * bus
                if earliestDepartureForBus < earliestDeparture {
                    earliestDepartureForBus += bus
                }
                
                result[bus] = earliestDepartureForBus
            })
        
        let busAndEarliestDeparture = earliestDepartureByAvailableBus
            .min(by: { first, second in
                return first.value < second.value
            })!
        
        return busAndEarliestDeparture.key * (busAndEarliestDeparture.value - earliestDeparture)
    }
    
    func part2(using buses: [Bus]) -> Int64 {
        let identifiers: [Int64] = buses.map({ bus in
            switch bus {
            case .inService(let identifier):
                return identifier
                
            case .any:
                return 1
            }
        })
        
        var increment = identifiers.first!
        var index = 1
        var timestamp = increment
        
        while index < identifiers.endIndex {
            let identifier = identifiers[index]
            
            if (timestamp + Int64(index)).isMultiple(of: identifier) {
                increment = leastCommonMultiple(increment, identifier)
                index = identifiers.index(after: index)
            }
            else {
                timestamp += increment
            }
        }
        
        return timestamp
    }
}

Day13.main()
