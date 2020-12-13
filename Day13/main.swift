//
//  main.swift
//  Day13
//
//  Created by Marc-Antoine Malépart on 2020-12-13.
//

import Foundation
import AdventOfCodeUtilities
import ArgumentParser

struct Day13: DayCommand {
    @Argument(help: "Puzzle input path")
    var puzzleInputPath: String
    
    func run() throws {
        let lines = try readLines()
        let earliestDeparture = Int(lines[0])!
        let availableBuses = lines[1].components(separatedBy: ",").compactMap({ Int($0) })
        
        let part1Solution = part1(earliestDeparture: earliestDeparture, availableBuses: availableBuses)
        printTitle("Title 1", level: .title1)
        print("Result:", part1Solution)
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
}

Day13.main()
