//
//  main.swift
//  Day15
//
//  Created by Marc-Antoine Malépart on 2020-12-15.
//

import Foundation
import AdventOfCodeUtilities
import ArgumentParser

struct Day15: DayCommand {
    @Argument(help: "Puzzle input path")
    var puzzleInputPath: String
    
    func run() throws {
        let numbers = try readFile().components(separatedBy: ",").compactMap({ Int($0) })
        
        let part1Solution = part1(with: numbers)
        printTitle("Part 1", level: .title1)
        print("2020th number:", part1Solution, terminator: "\n\n")
    }
    
    func part1(with numbers: [Int]) -> Int {
        var numbers = numbers
        var indicesByNumber: [Int: [Int]] = numbers.enumerated()
            .reduce(into: [:], { result, element in
                let (index, number) = element
                result[number] = [index]
            })
        var currentIndex = numbers.endIndex
        
        while currentIndex < 2020 {
            let lastNumber = numbers.last!
            
            let currentNumber: Int
            if let indices = indicesByNumber[lastNumber], indices.count > 1 {
                let lastTwoIndices = Array(indices.suffix(2))
                currentNumber = lastTwoIndices[1] - lastTwoIndices[0]
            }
            else {
                currentNumber = 0
            }
            
            numbers.append(currentNumber)
            indicesByNumber[currentNumber, default: []].append(currentIndex)
            
            currentIndex = numbers.index(after: currentIndex)
        }
        
        return numbers.last!
    }
}

Day15.main()
