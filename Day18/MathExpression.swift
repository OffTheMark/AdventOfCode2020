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
    
    init(_ text: String) {
        self.text = text
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
    
    private func reversePolishNotation(for tokens: [Token]) throws -> [Token] {
        var operators = Stack<Operation>()
        var output = [Token]()
        
        for token in tokens {
            switch token {
            case .value:
                output.append(token)
                
            case (.operation(let operation)):
                switch operation {
                case .add, .multiply:
                    while !operators.isEmpty, operators.peek() != .openingParenthesis {
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
    
    private func evaluate(_ notation: [Token]) -> Int {
        var stack = Stack<Int>()
        
        for token in notation {
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
    }
    
    enum Error: Swift.Error {
        case invalidToken(String)
        case mismatchedParentheses
    }
}

extension MathExpression.Token: Equatable {}
