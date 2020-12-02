//
//  PasswordPolicy.swift
//  Day2
//
//  Created by Marc-Antoine Malépart on 2020-12-02.
//

import Foundation
import AdventOfCodeUtilities

struct FirstPasswordPolicy {
    let character: Character
    let validCount: ClosedRange<Int>
    let password: String
    
    var isValid: Bool {
        let countOfCharacter = password.count(of: character)
        return validCount.contains(countOfCharacter)
    }
}

extension FirstPasswordPolicy {
    init?(rawValue: String) {
        let parts = rawValue.components(separatedBy: " ")
        
        guard parts.count == 3 else {
            return nil
        }
        
        let bounds = parts[0].components(separatedBy: "-").compactMap({ Int($0) })
        
        guard bounds.count == 2 else {
            return nil
        }
        
        let trimmedCharacterPart = parts[1].trimmingCharacters(in: .init(charactersIn: ":"))
        
        guard trimmedCharacterPart.count == 1 else {
            return nil
        }
        
        self.validCount = bounds[0] ... bounds[1]
        self.character = trimmedCharacterPart.first!
        self.password = parts[2]
    }
}

struct OfficialPasswordPolicy {
    let character: Character
    let validIndices: [Int]
    let password: String
    
    var isValid: Bool {
        let characterMatches = validIndices.count(where: { index in
            let stringIndex = password.index(password.startIndex, offsetBy: index)
            return password[stringIndex] == character
        })
        
        return characterMatches == 1
    }
}

extension OfficialPasswordPolicy {
    init?(rawValue: String) {
        let parts = rawValue.components(separatedBy: " ")
        
        guard parts.count == 3 else {
            return nil
        }
        
        let validIndices: [Int] = parts[0]
            .components(separatedBy: "-")
            .compactMap({ rawValue in
                guard let integer = Int(rawValue) else {
                    return nil
                }
                
                return integer - 1
            })
        
        guard validIndices.count == 2 else {
            return nil
        }
        
        let trimmedCharacterPart = parts[1].trimmingCharacters(in: .init(charactersIn: ":"))
        
        guard trimmedCharacterPart.count == 1 else {
            return nil
        }
        
        self.validIndices = validIndices
        self.character = trimmedCharacterPart.first!
        self.password = parts[2]
    }
}
