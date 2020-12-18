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
        
        let notation = reversePolishNotation(for: tokens)
        
        return evaluate(notation)
    }
    
    private func reversePolishNotation(for tokens: [Token]) -> [Token] {
        var operators = Stack<Token>()
        var output = [Token]()
        
        for token in tokens {
            switch token {
            case .value:
                output.append(token)
            
            case .addition, .multiplication:
                while !operators.isEmpty, operators.peek() != .openingParenthesis {
                    output.append(operators.pop())
                }
                
                operators.push(token)
                
            case .openingParenthesis:
                operators.push(token)
                
            case .closingParenthesis:
                while operators.peek() != .openingParenthesis {
                    output.append(operators.pop())
                }
                
                operators.pop()
            }
        }
        
        while !operators.isEmpty {
            output.append(operators.pop())
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
            
            let rhs = stack.pop()
            let lhs = stack.pop()
            
            switch token {
            case .addition:
                stack.push(lhs + rhs)
                
            case .multiplication:
                stack.push(lhs * rhs)
                
            default:
                continue
            }
        }
        
        return stack.pop()
    }
    
    enum Token {
        case value(Int)
        case addition
        case multiplication
        case openingParenthesis
        case closingParenthesis
            
        init?(rawValue: String)  {
            if let value = Int(rawValue) {
                self = .value(value)
                
                return
            }
            
            switch rawValue {
            case "+":
                self = .addition
                
            case "*":
                self = .multiplication
                
            case "(":
                self = .openingParenthesis
                
            case ")":
                self = .closingParenthesis
                
            default:
                return nil
            }
        }
    }
    
    enum Error: Swift.Error {
        case invalidToken(String)
    }
}

extension MathExpression.Token: Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case (.value(let left), .value(let right)):
            return left == right
            
        case (.addition, .addition),
             (.multiplication, .multiplication),
             (.openingParenthesis, .openingParenthesis),
             (.closingParenthesis, .closingParenthesis):
            return true
            
        default:
            return false
        }
    }
}
