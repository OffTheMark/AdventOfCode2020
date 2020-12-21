//
//  main.swift
//  Day21
//
//  Created by Marc-Antoine Malépart on 2020-12-21.
//

import Foundation
import AdventOfCodeUtilities
import ArgumentParser

struct Day21: DayCommand {
    @Argument(help: "Puzzle input path")
    var puzzleInputPath: String
    
    func run() throws {
        let lines = try readLines()
        let ingredientLists = lines.compactMap({ IngredientList(rawValue: $0) })
        
        var ingredientsByListIndex = [Int: Set<String>]()
        var listIndicesByAllergen = [String: Set<Int>]()
        var allIngredients = Set<String>()
        var allKnownAllergens = Set<String>()
        var listIndicesByIngredient = [String: Set<Int>]()
        
        for (index, ingredientList) in ingredientLists.enumerated() {
            ingredientsByListIndex[index] = ingredientList.ingredients
            allIngredients.formUnion(ingredientList.ingredients)
            allKnownAllergens.formUnion(ingredientList.knownAllergens)
            
            for allergen in ingredientList.knownAllergens {
                listIndicesByAllergen[allergen, default: []].insert(index)
            }
            
            for ingredient in ingredientList.ingredients {
                listIndicesByIngredient[ingredient, default: []].insert(index)
            }
        }
        
        var allergenIngredients = Set<String>()
        var confirmedIngredientByAllergen = [String: String]()
        
        while Set(confirmedIngredientByAllergen.keys) != allKnownAllergens {
            for (allergen, listIndices) in listIndicesByAllergen.filter({ $1.count > 1 }) {
                let possibleIngredientsForAllergen: Set<String> = listIndices.enumerated()
                    .reduce(into: [], { result, element in
                        let (index, listIndex) = element
                        
                        let currentIngredients = ingredientsByListIndex[listIndex]!.subtracting(allergenIngredients)
                        
                        if index == 0 {
                            result = currentIngredients
                            return
                        }
                        
                        result.formIntersection(currentIngredients)
                    })
                
                if possibleIngredientsForAllergen.count == 1, let ingredient = possibleIngredientsForAllergen.first {
                    confirmedIngredientByAllergen[allergen] = ingredient
                    allergenIngredients.insert(ingredient)
                }
            }
            
            for (allergen, listIndices) in listIndicesByAllergen.filter({ $1.count == 1 }) {
                let index = listIndices.first!
                
                let ingredients = ingredientsByListIndex[index]!
                
                if ingredients.count == 1, let ingredient = ingredients.first {
                    confirmedIngredientByAllergen[allergen] = ingredient
                    allergenIngredients.insert(ingredient)
                }
            }
        }
        
        let nonAllergenIngredients = allIngredients.subtracting(allergenIngredients)
        
        let part1Solution = nonAllergenIngredients.reduce(into: 0, { result, ingredient in
            result += listIndicesByIngredient[ingredient, default: []].count
        })
        
        printTitle("Part 1", level: .title1)
        print("Count:", part1Solution, terminator: "\n\n")
        
        let part2Solution = confirmedIngredientByAllergen
            .sorted(by: { $0.key < $1.key })
            .reduce(into: [], { result, element in
                let (_, ingredient) = element
                result.append(ingredient)
            })
            .joined(separator: ",")
        
        printTitle("Part2", level: .title1)
        print("Canonical dangerous ingredient list:", part2Solution)
    }
    
    func part1(with ingredientLists: [IngredientList]) -> Int {
        var ingredientsByListIndex = [Int: Set<String>]()
        var listIndicesByAllergen = [String: Set<Int>]()
        var allIngredients = Set<String>()
        var allKnownAllergens = Set<String>()
        var listIndicesByIngredient = [String: Set<Int>]()
        
        for (index, ingredientList) in ingredientLists.enumerated() {
            ingredientsByListIndex[index] = ingredientList.ingredients
            allIngredients.formUnion(ingredientList.ingredients)
            allKnownAllergens.formUnion(ingredientList.knownAllergens)
            
            for allergen in ingredientList.knownAllergens {
                listIndicesByAllergen[allergen, default: []].insert(index)
            }
            
            for ingredient in ingredientList.ingredients {
                listIndicesByIngredient[ingredient, default: []].insert(index)
            }
        }
        
        var allergenIngredients = Set<String>()
        var confirmedIngredientByAllergen = [String: String]()
        
        while Set(confirmedIngredientByAllergen.keys) != allKnownAllergens {
            for (allergen, listIndices) in listIndicesByAllergen.filter({ $1.count > 1 }) {
                let possibleIngredientsForAllergen: Set<String> = listIndices.enumerated()
                    .reduce(into: [], { result, element in
                        let (index, listIndex) = element
                        
                        let currentIngredients = ingredientsByListIndex[listIndex]!.subtracting(allergenIngredients)
                        
                        if index == 0 {
                            result = currentIngredients
                            return
                        }
                        
                        result.formIntersection(currentIngredients)
                    })
                
                if possibleIngredientsForAllergen.count == 1, let ingredient = possibleIngredientsForAllergen.first {
                    confirmedIngredientByAllergen[allergen] = ingredient
                    allergenIngredients.insert(ingredient)
                }
            }
            
            for (allergen, listIndices) in listIndicesByAllergen.filter({ $1.count == 1 }) {
                let index = listIndices.first!
                
                let ingredients = ingredientsByListIndex[index]!
                
                if ingredients.count == 1, let ingredient = ingredients.first {
                    confirmedIngredientByAllergen[allergen] = ingredient
                    allergenIngredients.insert(ingredient)
                }
            }
        }
        
        let nonAllergenIngredients = allIngredients.subtracting(allergenIngredients)
        
        return nonAllergenIngredients.reduce(into: 0, { result, ingredient in
            result += listIndicesByIngredient[ingredient, default: []].count
        })
    }
}

Day21.main()
