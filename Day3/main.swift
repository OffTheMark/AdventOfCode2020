//
//  main.swift
//  Day3
//
//  Created by Marc-Antoine Malépart on 2020-12-02.
//

import Foundation
import AdventOfCodeUtilities
import ArgumentParser

struct Day3: DayCommand {
    @Argument(help: "Puzzle input path")
    var puzzleInputPath: String
    
    func run() throws {
        let lines = try readLines()
        
        #warning("TODO: Complete day 3")
    }
}

Day3.main()
