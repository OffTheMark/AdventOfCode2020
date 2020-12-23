//
//  main.swift
//  Day23
//
//  Created by Marc-Antoine Malépart on 2020-12-23.
//

import Foundation
import AdventOfCodeUtilities
import ArgumentParser

final class Node<Element> {
    let value: Element
    var next: Node?
    
    init(value: Element) {
        self.value = value
    }
}

struct Day23: DayCommand {
    @Argument(help: "Puzzle input path")
    var puzzleInputPath: String
    
    func run() throws {
        let content = try readFile()
        let numbers = content.compactMap({ Int(String($0)) })
        
        printTitle("Part 1", level: .title1)
        let part1Solution = part1(with: numbers)
        print("Labels on cups:", part1Solution, terminator: "\n\n")
        
        printTitle("Part 2", level: .title1)
        let part2Solution = part2(with: numbers)
        print("Product:", part2Solution)
    }
    
    func part1(with numbers: [Int]) -> String {
        var head = Node(value: numbers.first!)
        var nodesByCup: [Int: Node<Int>] = [head.value: head]
        var previous = head
        
        for number in numbers.dropFirst() {
            let next = Node(value: number)
            previous.next = next
            
            nodesByCup[number] = next
            
            previous = next
        }
        
        previous.next = head
        
        for _ in 0 ..< 100 {
            var removedValues = Set<Int>()
            
            let removedHead = head.next!
            var removedTail = head
            for _ in 0 ..< 3 {
                removedTail = removedTail.next!
                removedValues.insert(removedTail.value)
            }
            
            var destinationCup = head.value - 1
            if destinationCup < 1 {
                destinationCup = 9
            }
            
            while removedValues.contains(destinationCup) {
                destinationCup -= 1
                
                if destinationCup == 0 {
                    destinationCup = 9
                }
            }
            
            let destinationNode = nodesByCup[destinationCup]!
            let nodeAfterDestination = destinationNode.next!
            let nodeAfterRemovedTail = removedTail.next!
            
            removedTail.next = nodeAfterDestination
            destinationNode.next = removedHead
            head.next = nodeAfterRemovedTail
            
            head = head.next!
        }
        
        var output = ""
        var currentNode = nodesByCup[1]!.next!
        repeat {
            output.append(String(currentNode.value))
            currentNode = currentNode.next!
        }
        while currentNode.value != 1
        
        return output
    }
    
    func part2(with numbers: [Int]) -> Int {
        var head = Node(value: numbers.first!)
        var nodesByCup: [Int: Node<Int>] = [head.value: head]
        var previous = head
        
        for number in numbers.dropFirst() {
            let next = Node(value: number)
            previous.next = next
            
            nodesByCup[number] = next
            
            previous = next
        }
        
        for number in (numbers.max()! + 1) ... 1_000_000 {
            let next = Node(value: number)
            previous.next = next
            
            nodesByCup[number] = next
            previous = next
        }
        
        previous.next = head
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        
        for turn in 0 ..< 10_000_000 {
            if turn.isMultiple(of: 100_000) {
                print("Progress:", formatter.string(from: NSNumber(value: Float(turn) / 10_000_000))!)
            }
            
            var removedValues = Set<Int>()
            let removedHead = head.next!
            var removedTail = head
            for _ in 0 ..< 3 {
                removedTail = removedTail.next!
                removedValues.insert(removedTail.value)
            }
            
            var destinationCup = head.value - 1
            if destinationCup < 1 {
                destinationCup = 1_000_000
            }
            
            while removedValues.contains(destinationCup) {
                destinationCup -= 1
                
                if destinationCup == 0 {
                    destinationCup = 1_000_000
                }
            }
            
            let destinationNode = nodesByCup[destinationCup]!
            let nodeAfterDestination = destinationNode.next!
            let nodeAfterRemovedTail = removedTail.next!
            
            head.next = nodeAfterRemovedTail
            destinationNode.next = removedHead
            removedTail.next = nodeAfterDestination
            
            head = head.next!
        }
        print("Progress:", formatter.string(from: 1)!)
        
        var result = 1
        var current = nodesByCup[1]!
        for _ in 0 ..< 2 {
            current = current.next!
            result *= current.value
        }
        
        return result
    }
}

Day23.main()
