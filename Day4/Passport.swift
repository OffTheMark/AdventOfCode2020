//
//  Passport.swift
//  Day4
//
//  Created by Marc-Antoine Malépart on 2020-12-04.
//

import Foundation

struct Passport {
    private let valuesByField: [Field: String]
    
    init(rawValue: String) {
        let parts = rawValue.components(separatedBy: .whitespacesAndNewlines)
        
        self.valuesByField = parts.reduce(into: [:], { result, part in
            let components = part.components(separatedBy: ":")
            guard components.count == 2 else {
                return
            }
            
            guard let field = Field(rawValue: components[0]) else {
                return
            }
            
            result[field] = components[1]
        })
    }
    
    func hasField(_ field: Field) -> Bool {
        valuesByField.keys.contains(field)
    }
}

enum Field: String {
    case birthYear = "byr"
    case issueYear = "iyr"
    case expirationYear = "eyr"
    case height = "hgt"
    case hairColor = "hcl"
    case eyeColor = "ecl"
    case passportID = "pid"
    case countryID = "cid"
}
