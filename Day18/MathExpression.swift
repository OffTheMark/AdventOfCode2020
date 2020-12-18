//
//  MathExpression.swift
//  Day18
//
//  Created by Marc-Antoine Malépart on 2020-12-18.
//

import Foundation
import SwiftDataStructures

struct MathExpression {
    let text: String
    let mode: Mode
    
    init(_ text: String, mode: Mode) {
        self.text = text
        self.mode = mode
    }
    
    func evaluate() throws -> Int {
        let tokens: [Token] = try text
            .replacingOccurrences(of: "(", with: "( ")
            .replacingOccurrences(of: ")", with: " )")
            .components(separatedBy: .whitespaces)
            .map({ rawValue in
                guard let token = Token(rawValue: rawValue) else {
                    throw Error.invalidToken(rawValue)
                }
                
                return token
            })
        let notation = try reversePolishNotation(for: tokens)
        
        return evaluate(notation)
    }
    
    /// Transforms the tokens to Reverse Polish Notation using the shunting-yard algorithm.
    ///
    /// The implementation is based on the algorithm's [Wikipedia page.](https://en.wikipedia.org/wiki/Shunting-yard_algorithm)
    private func reversePolishNotation(for infixNotation: [Token]) throws -> [Token] {
        var operators = Stack<Operation>()
        var output = [Token]()
        
        for token in infixNotation {
            switch token {
            case .value:
                output.append(token)
                
            case (.operation(let operation)):
                switch operation {
                case .add, .multiply:
                    while !operators.isEmpty {
                        let peeked: Operation = operators.peek()!
                        
                        guard peeked.precedence(in: mode) > operation.precedence(in: mode) ||
                                (peeked.precedence(in: mode) == operation.precedence(in: mode) && operation.isLeftAssociative),
                              peeked != .openingParenthesis else {
                            break
                        }
                        
                        let operatorToken: Token = .operation(operators.pop())
                        output.append(operatorToken)
                    }
                    
                    operators.push(operation)
                    
                case .openingParenthesis:
                    operators.push(operation)
                    
                case .closingParenthesis:
                    while operators.peek() != .openingParenthesis {
                        let operatorToken: Token = .operation(operators.pop())
                        output.append(operatorToken)
                    }
                    
                    if operators.isEmpty {
                        throw Error.mismatchedParentheses
                    }
                    
                    operators.pop()
                }
            }
        }
        
        while !operators.isEmpty {
            let operation = operators.pop()
            
            switch operation {
            case .add, .multiply:
                output.append(.operation(operation))
                
            case .openingParenthesis, .closingParenthesis:
                throw Error.mismatchedParentheses
            }
        }
        
        return output
    }
    
    /// Evaluates the expression in postfix notation (or Reverse Polish Notation).
    ///
    /// The implementation is based on [this article](https://www.geeksforgeeks.org/stack-set-4-evaluation-postfix-expression/).
    private func evaluate(_ postfixNotation: [Token]) -> Int {
        var stack = Stack<Int>()
        
        for token in postfixNotation {
            if case .value(let value) = token {
                stack.push(value)
                continue
            }
            
            switch token {
            case .value(let value):
                stack.push(value)
                
            case .operation(let operation):
                let rhs = stack.pop()
                let lhs = stack.pop()
                
                switch operation {
                case .add:
                    stack.push(lhs + rhs)
                    
                case .multiply:
                    stack.push(lhs * rhs)
                    
                default:
                    continue
                }
            }
        }
        
        return stack.pop()
    }
    
    enum Mode {
        case part1
        case part2
    }
    
    fileprivate enum Token {
        case value(Int)
        case operation(Operation)
            
        init?(rawValue: String)  {
            if let value = Int(rawValue) {
                self = .value(value)
                
                return
            }
            
            guard let operation = Operation(rawValue: rawValue) else {
                return nil
            }
            
            self = .operation(operation)
        }
    }
    
    fileprivate enum Operation: String {
        case add = "+"
        case multiply = "*"
        case openingParenthesis = "("
        case closingParenthesis = ")"
        
        func precedence(in mode: Mode) -> Int {
            switch (self, mode) {
            case (.add, .part1),
                 (.add, .part2),
                 (.multiply, .part1):
                return 1
                
            case (.multiply, .part2):
                return 0
            
            case (.openingParenthesis, _),
                 (.closingParenthesis, _):
                return 2
            }
        }
        
        var isLeftAssociative: Bool {
            switch self {
            case .add, .multiply:
                return true
                
            case .openingParenthesis, .closingParenthesis:
                return false
            }
        }
    }
    
    enum Error: Swift.Error {
        case invalidToken(String)
        case mismatchedParentheses
    }
}

extension MathExpression.Token: Equatable {}
