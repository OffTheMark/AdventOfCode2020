//
//  main.swift
//  Day25
//
//  Created by Marc-Antoine Malépart on 2020-12-25.
//

import Foundation
import AdventOfCodeUtilities
import ArgumentParser

struct Day25: DayCommand {
    @Argument(help: "Puzzle input path")
    var puzzleInputPath: String
    
    func run() throws {
        let lines = try readLines()
        let publicKeys = lines.compactMap({ Int($0) })
        
        printTitle("Part 1", level: .title1)
        let loopSizesByPublicKey = part1(with: publicKeys)
        
        let publicKey = publicKeys[0]
        let loopSize = loopSizesByPublicKey[publicKeys[1]]!
        let part1Solution = transform(subjectNumber: publicKey, loopSize: loopSize)
        print("Encryption key:", part1Solution, terminator: "\n\n")
    }
    
    func part1(with publicKeys: [Int]) -> [Int: Int] {
        var loopSizesByPublicKey = [Int: Int]()
        
        for publicKey in publicKeys {
            var loopSize = 0
            let subjectNumber = 7
            var value = 1
            
            repeat {
                value *= subjectNumber
                value = value % 20201227
                
                loopSize += 1
            }
            while value != publicKey
            
            loopSizesByPublicKey[publicKey] = loopSize
        }
        
        return loopSizesByPublicKey
    }
    
    func transform(subjectNumber: Int, loopSize: Int) -> Int {
        var value = 1
        
        for _ in 0 ..< loopSize {
            value *= subjectNumber
            value = value % 20201227
        }
        
        return value
    }
}

Day25.main()
