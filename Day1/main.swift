//
//  main.swift
//  Day1
//
//  Created by Marc-Antoine Malépart on 2020-11-26.
//

import Foundation
import AdventOfCodeUtilities
import ArgumentParser

struct Day1: DayCommand {
    @Argument(help: "Puzzle input path")
    var puzzleInputPath: String
    
    func run() throws {
        let input = try readFile()
        
        #warning("TODO: Part 1")
    }
}

Day1.main()
