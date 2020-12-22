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
    
    func snapshot() -> Snapshot {
        Snapshot(firstScore: first.score(), secondScore: second.score())
    }
    
    struct Snapshot {
        let firstScore: Int
        let secondScore: Int
    }
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

extension State.Snapshot: Hashable {}

extension State: Hashable {}

struct Deck {
    let player: Player
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
        guard let playerNumber = Int(firstLine.removingPrefix("Player ").removingSuffix(":")),
              let player = Player(rawValue: playerNumber) else {
            return nil
        }
        
        self.player = player
        self.cards = Deque(lines.compactMap({ Int($0) }))
    }
}

extension Deck: Hashable {}

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

enum Player: Int {
    case first = 1
    case second = 2
}

struct CombatGame {
    var state: State
    
    mutating func play() -> Deck {
        while state.canPlayRound {
            let firstTopCard = state.first.cards.removeFirst()
            let secondTopCard = state.second.cards.removeFirst()
            
            let roundWinner: Player
            if firstTopCard > secondTopCard {
                roundWinner = .first
            } else {
                roundWinner = .second
            }
            
            switch roundWinner  {
            case .first:
                state.first.cards.append(contentsOf: [firstTopCard, secondTopCard])
            case .second:
                state.second.cards.append(contentsOf: [secondTopCard, firstTopCard])
            }
        }
        
        return [state.first, state.second].first(where: { $0.isEmpty == false })!
    }
}

struct RecurseCombatGame {
    private static var currentGameNumber = 1
    
    let number: Int
    
    var state: State
    
    init(state: State) {
        self.number = Self.currentGameNumber
        self.state = state
        
        Self.currentGameNumber += 1
    }
    
    mutating func play() -> Deck {
        var currentRound = 1
        var visitedSnapshots = Set<State.Snapshot>()
        
        while state.canPlayRound {
            let snapshot = state.snapshot()
            let (wasInserted, _) = visitedSnapshots.insert(snapshot)
            
            if wasInserted == false {
                return state.first
            }
            
            let firstTopCard = state.first.cards.removeFirst()
            let secondTopCard = state.second.cards.removeFirst()
            
            let shouldPlaySubgame = zip([state.first, state.second], [firstTopCard, secondTopCard])
                .allSatisfy({ state, card in
                    state.cards.count >= card
                })
            
            let roundWinner: Player
            if shouldPlaySubgame {
                let firstDeck = Deck(
                    player: state.first.player,
                    cards: Deque(state.first.cards.prefix(firstTopCard))
                )
                let secondDeck = Deck(
                    player: state.second.player,
                    cards: Deque(state.second.cards.prefix(secondTopCard))
                )
                let stateForSubgame = State(first: firstDeck, second: secondDeck)
                var game = RecurseCombatGame(state: stateForSubgame)
                let winner = game.play()
                
                roundWinner = winner.player
            }
            else if firstTopCard > secondTopCard {
                roundWinner = .first
            }
            else {
                roundWinner = .second
            }
            
            switch roundWinner {
            case .first:
                state.first.cards.append(contentsOf: [firstTopCard, secondTopCard])
                
            case .second:
                state.second.cards.append(contentsOf: [secondTopCard, firstTopCard])
            }
            
            currentRound += 1
        }
        
        let winner = [state.first, state.second].first(where: { $0.isEmpty == false })!
        return winner
    }
}
