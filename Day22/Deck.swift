//
//  Deck.swift
//  Day22
//
//  Created by Marc-Antoine Malépart on 2020-12-22.
//

import Foundation
import SwiftDataStructures

struct State {
    var first: Deck
    var second: Deck
    
    var canPlayRound: Bool { [first, second].allSatisfy({ $0.isEmpty == false }) }
}

extension State {
    init?(rawValue: String) {
        let deckRawValues = rawValue.components(separatedBy: "\n\n")
        
        guard deckRawValues.count == 2 else {
            return nil
        }
        
        guard let first = Deck(rawValue: deckRawValues[0]), let second = Deck(rawValue: deckRawValues[1]) else {
            return nil
        }
        
        self.first = first
        self.second = second
    }
}

struct Deck {
    let playerNumber: Int
    var cards: Deque<Int>
    
    var isEmpty: Bool { cards.isEmpty }
    
    func score() -> Int {
        return zip(cards.reversed(), 1...)
            .reduce(into: 0, { score, element in
                let (card, multiplier) = element
                score += card * multiplier
            })
    }
}

extension Deck {
    init?(rawValue: String) {
        var lines = rawValue.components(separatedBy: .newlines)
        
        guard lines.count >= 1 else {
            return nil
        }
        
        let firstLine = lines.removeFirst()
        guard let playerNumber = Int(firstLine.removingPrefix("Player ").removingSuffix(":")) else {
            return nil
        }
        
        self.playerNumber = playerNumber
        self.cards = Deque(lines.compactMap({ Int($0) }))
    }
}

extension String {
    func removingPrefix(_ prefix: String) -> String {
        guard self.hasPrefix(prefix) else {
            return self
        }
        
        return String(self.dropFirst(prefix.count))
    }
    
    func removingSuffix(_ suffix: String) -> String {
        guard self.hasSuffix(suffix) else {
            return self
        }
        
        return String(self.dropLast(suffix.count))
    }
}
