//
//  main.swift
//  Day10
//
//  Created by Marc-Antoine Malépart on 2020-12-10.
//

import Foundation
import AdventOfCodeUtilities
import ArgumentParser
import SwiftDataStructures

struct Day10: DayCommand {
    @Argument(help: "Puzzle input path")
    var puzzleInputPath: String
    
    func run() throws {
        let adapters: [Int] = try readLines().compactMap({ Int($0) })
        
        let part1Solution = part1(using: adapters)
    }
    
    func part1(using adapters: [Int]) -> Int {
        func findPath(using adapters: [Int]) -> [Int] {
            let deviceAdapterRating = adapters.max()! + 3
            
            var queue = Queue<[Int]>()
            queue.enqueue([0])
            
            var discovered = Set<[Int]>()
            discovered.insert([0])
            
            while !queue.isEmpty {
                let dequeued = queue.dequeue()
                let last = dequeued.last!
                
                if dequeued.count == adapters.count, (deviceAdapterRating - 2 ... deviceAdapterRating).contains(last) {
                    return dequeued
                }
                
                let neighbors = adapters
                    .filter({ rating in
                        if dequeued.contains(rating) {
                            return false
                        }
                        
                        return (last + 1 ... last + 3).contains(rating)
                    })
                    .map({ lastRating in
                        return dequeued + [lastRating]
                    })
                
                for neighbor in neighbors where !discovered.contains(neighbor) {
                    queue.enqueue(neighbor)
                    discovered.insert(neighbor)
                }
            }
            
            fatalError("Invalid state")
        }
        
        let path = findPath(using: adapters)
        
        return 0
    }
}

Day10.main()
