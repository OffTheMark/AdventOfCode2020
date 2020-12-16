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
        
        let part2Solution = part2(with: numbers)
        printTitle("Part 2", level: .title1)
        print("30000000th number:", part2Solution)
    }
    
    func part1(with numbers: [Int]) -> Int {
        let game = Game(numbers: numbers, numberOfTurns: 2020)
        return game.play()
    }
    
    func part2(with numbers: [Int]) -> Int {
        let game = Game(numbers: numbers, numberOfTurns: 30_000_000)
        return game.play()
    }
}

struct Game {
    let numbers: [Int]
    let numberOfTurns: Int
    
    func play() -> Int {
        var indicesByNumber: [Int: Int] = numbers.enumerated()
            .reduce(into: [:], { result, element in
                let (index, number) = element
                result[number] = index
            })
        
        var currentIndex = numbers.endIndex
        var previousNumber = numbers.last!
        
        while currentIndex < numberOfTurns {
            let currentNumber: Int
            if let lastIndex = indicesByNumber[previousNumber] {
                currentNumber = numbers.index(before: currentIndex) - lastIndex
            }
            else {
                currentNumber = 0
            }
            
            indicesByNumber[previousNumber] = numbers.index(before: currentIndex)
            currentIndex = numbers.index(after: currentIndex)
            previousNumber = currentNumber
        }
        
        return previousNumber
    }
}

Day15.main()
