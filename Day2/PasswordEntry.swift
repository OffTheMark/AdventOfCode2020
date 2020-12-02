//
//  PasswordEntry.swift
//  Day2
//
//  Created by Marc-Antoine Malépart on 2020-12-02.
//

import Foundation

struct PasswordEntry {
    let character: Character
    let validCount: ClosedRange<Int>
    let password: String
}

extension PasswordEntry {
    init?(rawValue: String) {
        let parts = rawValue.components(separatedBy: " ")
        
        guard parts.count == 3 else {
            return nil
        }
        
        let bounds = parts[0].components(separatedBy: "-").compactMap({ Int($0) })
        
        guard bounds.count == 2 else {
            return nil
        }
        
        let trimmedLastPart = parts[1].trimmingCharacters(in: .init(charactersIn: ":"))
        
        guard trimmedLastPart.count == 1 else {
            return nil
        }
        
        self.validCount = bounds[0] ... bounds[1]
        self.character = trimmedLastPart.first!
        self.password = parts[2]
    }
}

extension Sequence {
    func count(where predicate: @escaping (Element) throws -> Bool) rethrows -> Int {
        return try reduce(into: 0, { count, element in
            if try predicate(element) {
                count += 1
            }
        })
    }
}

extension Sequence where Element: Equatable {
    func count(of element: Element) -> Int {
        return count(where: { $0 == element })
    }
}
