//
//  main.swift
//  Day18
//
//  Created by Marc-Antoine Malépart on 2020-12-18.
//

import Foundation
import AdventOfCodeUtilities
import ArgumentParser
import Expression
import SwiftDataStructures

struct Day18: DayCommand {
    @Argument(help: "Puzzle input path")
    var puzzleInputPath: String
    
    func run() throws {
        let lines = try readLines()
        
        let part1Solution = try part1(with: lines)
        printTitle("Part 1", level: .title1)
        print("Sum:", part1Solution, terminator: "\n\n")
    }
    
    func part1(with lines: [String]) throws -> Int {
        var result = 0
        for line in lines {
            let tokens = line
                .replacingOccurrences(of: "(", with: "( ")
                .replacingOccurrences(of: ")", with: " )")
                .components(separatedBy: " ")
            let notation = reversePolishNotation(for: tokens)
            let value = evaluateReversePolishNotation(notation)
            
            result += value
        }
        
        return result
    }
    
    func reversePolishNotation(for tokens: [String]) -> [String] {
        var operatorStack = Stack<String>()
        var output = [String]()
        
        for token in tokens {
            switch token {
            case let token where Int(token) != nil:
                output.append(token)
                
            case "*", "+":
                while !operatorStack.isEmpty, operatorStack.peek() != "(" {
                    output.append(operatorStack.pop())
                }
                
                operatorStack.push(token)
                
            case "(":
                operatorStack.push("(")
                
            case ")":
                while operatorStack.peek() != "(" {
                    output.append(operatorStack.pop())
                }
                operatorStack.pop()
                
            default:
                break
            }
        }
        
        while !operatorStack.isEmpty {
            output.append(operatorStack.pop())
        }
        
        return output
    }
    
    func evaluateReversePolishNotation(_ notation: [String]) -> Int {
        var stack = Stack<Int>()
        
        for token in notation {
            if let value = Int(token) {
                stack.push(value)
                continue
            }
            
            let rhs = stack.pop()
            let lhs = stack.pop()
            
            switch token {
            case "*":
                stack.push(lhs * rhs)
                
            case "+":
                stack.push(lhs + rhs)
                
            default:
                continue
            }
        }
        
        return stack.pop()
    }
}

Day18.main()
