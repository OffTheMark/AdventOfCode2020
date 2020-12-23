//
//  main.swift
//  Day23
//
//  Created by Marc-Antoine Malépart on 2020-12-23.
//

import Foundation
import AdventOfCodeUtilities
import ArgumentParser
import SwiftDataStructures

struct Day23: DayCommand {
    @Argument(help: "Puzzle input path")
    var puzzleInputPath: String
    
    func run() throws {
        let content = try readFile()
        let numbers = content.compactMap({ Int(String($0)) })
        
        let part1Solution = part1(with: numbers)
        printTitle("Part 1", level: .title1)
        print("Labels on cups:", part1Solution, terminator: "\n\n")
    }
    
    func part1(with numbers: [Int]) -> String {
        var deque = Deque(numbers)
        
        for _ in 0 ..< 100 {
            let currentCup = deque.first!
            var removedCups = [Int]()
            
            for _ in 0 ..< 3 {
                removedCups.append(deque.remove(at: 1))
            }
            
            let destinationCup: Int
            let remainingCupsLowerThanCurrent = deque.filter({ $0 < currentCup }).sorted(by: >)
            
            if let highestCupLowerThanCurrent = remainingCupsLowerThanCurrent.first {
                destinationCup = highestCupLowerThanCurrent
            }
            else {
                destinationCup = deque.max()!
            }
            
            let destinationIndex = deque.firstIndex(of: destinationCup)!
            for (index, cup) in zip((destinationIndex + 1)..., removedCups) {
                deque.insert(cup, at: index)
            }
            
            deque.rotateLeft()
        }
        
        let indexOfOne = deque.firstIndex(of: 1)!
        var orderAfterCupOne = deque
        if indexOfOne > 0 {
            orderAfterCupOne.rotateLeft(by: indexOfOne)
        }
        orderAfterCupOne.removeFirst()
        
        return orderAfterCupOne.map({ String($0) }).joined()
    }
}

Day23.main()
