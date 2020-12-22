//
//  main.swift
//  Day22
//
//  Created by Marc-Antoine Malépart on 2020-12-22.
//

import Foundation
import AdventOfCodeUtilities
import ArgumentParser

struct Day22: DayCommand {
    @Argument(help: "Puzzle input path")
    var puzzleInputPath: String
    
    func run() throws {
        let decks = try readFile()
            .components(separatedBy: "\n\n")
            .compactMap({ Deck(rawValue: $0) })
        
        let part1Solution = part1(using: (decks[0], decks[1]))
        printTitle("Part 1", level: .title1)
        print("Score:", part1Solution, terminator: "\n\n")
    }
    
    func part1(using decks: (first: Deck, second: Deck)) -> Int {
        var firstDeck = decks.first
        var secondDeck = decks.second
        
        while firstDeck.isEmpty == false, secondDeck.isEmpty == false {
            let firstTopCard = firstDeck.cards.removeFirst()
            let secondTopCard = secondDeck.cards.removeFirst()
            
            if firstTopCard > secondTopCard {
                firstDeck.cards.append(firstTopCard)
                firstDeck.cards.append(secondTopCard)
            }
            else {
                secondDeck.cards.append(secondTopCard)
                secondDeck.cards.append(firstTopCard)
            }
        }
        
        return [firstDeck, secondDeck]
            .first(where: { $0.isEmpty == false })!
            .score()
    }
}

Day22.main()
