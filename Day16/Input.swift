//
//  Input.swift
//  Day16
//
//  Created by Marc-Antoine Malépart on 2020-12-16.
//

import Foundation

struct Input {
    let rulesByField: [String: Rule]
    let ticket: Ticket
    var otherTickets: [Ticket]
}

extension Input {
    init?(rawValue: String) {
        let parts = rawValue.components(separatedBy: "\n\n")
        guard parts.count == 3 else {
            return nil
        }
        
        self.rulesByField = parts[0].components(separatedBy: .newlines)
            .reduce(into: [:], { result, line in
                let parts = line.components(separatedBy: ": ")
                guard parts.count == 2 else {
                    return
                }
                
                guard let rule = Rule(rawValue: parts[1]) else {
                    return
                }
                
                result[parts[0]] = rule
            })
        
        let ticketParts = parts[1].components(separatedBy: .newlines)
        guard ticketParts.count == 2, let ticket = Ticket(rawValue: ticketParts[1]) else {
            return nil
        }
        
        self.ticket = ticket
        
        let otherTicketParts = parts[2].components(separatedBy: .newlines).dropFirst()
        self.otherTickets = otherTicketParts.compactMap({ Ticket(rawValue: $0) })
    }
}

struct Ticket {
    let numbers: [Int]
}

extension Ticket {
    init?(rawValue: String) {
        self.numbers = rawValue.components(separatedBy: ",").compactMap({ Int($0) })
    }
}

struct Rule {
    let validRanges: [ClosedRange<Int>]
    
    func isIncluded(_ value: Int) -> Bool {
        validRanges.contains(where: { $0.contains(value) })
    }
}

extension Rule {
    init?(rawValue: String) {
        let rangeRawValues = rawValue.components(separatedBy: " or ")
        
        self.validRanges = rangeRawValues.compactMap({ rangeRawValue in
            let bounds = rangeRawValue.components(separatedBy: "-").compactMap({ Int($0) })
            
            guard bounds.count == 2 else {
                return nil
            }
            
            return bounds[0] ... bounds[1]
        })
        
    }
}
