//
//  IngredientList.swift
//  Day21
//
//  Created by Marc-Antoine Malépart on 2020-12-21.
//

import Foundation

struct IngredientList {
    var ingredients: Set<Ingredient>
    var knownAllergens: Set<Allergen>
}

extension IngredientList {
    init?(rawValue: String) {
        let parts = rawValue.components(separatedBy: " (contains ")
        
        switch parts.count {
        case 2:
            self.knownAllergens = Set(parts[1].removingSuffix(")").components(separatedBy: ", ").map({ Allergen(rawValue: $0) }))
            
        case 1:
            self.knownAllergens = []
            
        default:
            return nil
        }
        
        self.ingredients = Set(parts[0].components(separatedBy: " ").map({ Ingredient(rawValue: $0) }))
    }
}

extension String {
    func removingSuffix(_ suffix: String) -> String {
        guard self.hasSuffix(suffix) else {
            return self
        }
        
        return String(self.dropLast(suffix.count))
    }
}

struct Allergen {
    let rawValue: String
}

extension Allergen: Hashable {}

extension Allergen: Equatable {}

extension Allergen: Comparable {
    static func < (lhs: Allergen, rhs: Allergen) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}

struct Ingredient {
    let rawValue: String
}

extension Ingredient: Hashable {}

extension Ingredient: Equatable {}

extension Ingredient: CustomStringConvertible {
    var description: String { rawValue }
}
