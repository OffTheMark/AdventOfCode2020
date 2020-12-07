//
//  LuggageRule.swift
//  Day7
//
//  Created by Marc-Antoine Malépart on 2020-12-07.
//

import Foundation

struct LuggageRule {
    let luggage: Luggage
    let allowedContents: [(luggage: Luggage, count: Int)]
    
    var distinctContents: Set<Luggage> {
        Set(allowedContents.map({ $0.luggage }))
    }
}

extension LuggageRule {
    init?(rawValue: String) {
        var words = rawValue.trimmingCharacters(in: .init(charactersIn: ".")).components(separatedBy: " ")
        self.luggage = Luggage(name: words[0...1].joined(separator: " "))
        words.removeFirst(4)
        let remaining = words.joined(separator: " ").components(separatedBy: ", ")
        
        if remaining.count == 1, remaining[0] == "no other bags" {
            self.allowedContents = []
            return
        }
        
        var allowedContents: [(luggage: Luggage, count: Int)] = []
        for entry in remaining {
            let parts = entry.components(separatedBy: " ")
            guard parts.count == 4 else {
                continue
            }
            
            guard let count = Int(parts[0]) else {
                continue
            }
            
            let name = parts[1...2].joined(separator: " ")
            let content = (Luggage(name: name), count)
            allowedContents.append(content)
        }
        
        self.allowedContents = allowedContents
    }
}

struct Luggage {
    let name: String
    
    static let shinyGold = Luggage(name: "shiny gold")
}

extension Luggage: Hashable {}

extension Luggage: Equatable {}
