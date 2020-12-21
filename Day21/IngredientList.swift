//
//  IngredientList.swift
//  Day21
//
//  Created by Marc-Antoine Malépart on 2020-12-21.
//

import Foundation

struct IngredientList {
    var ingredients: Set<String>
    var knownAllergens: Set<String>
}

extension IngredientList {
    init?(rawValue: String) {
        let parts = rawValue.components(separatedBy: " (contains ")
        
        switch parts.count {
        case 2:
            self.knownAllergens = Set(parts[1].removingSuffix(")").components(separatedBy: ", "))
            
        case 1:
            self.knownAllergens = []
            
        default:
            return nil
        }
        
        self.ingredients = Set(parts[0].components(separatedBy: " "))
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
