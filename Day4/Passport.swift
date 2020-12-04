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
    
    var hasAllRequiredFields: Bool {
        Self.requiredFields.allSatisfy({ hasField($0) })
    }
    
    var hasAllValidFields: Bool {
        return isBirthYearValid &&
            isIssueYearValid &&
            isExpirationYearValid &&
            isHeightValid &&
            isHairColorValid &&
            isEyeColorValid &&
            isPassportIDValid
    }
    
    static let requiredFields: Set<Field> = [.birthYear, .issueYear, .expirationYear, .height, .hairColor, .eyeColor, .passportID]
    
    var isBirthYearValid: Bool {
        guard let rawValue = valuesByField[.birthYear], rawValue.count == 4 else {
            return false
        }
        
        guard let year = Int(rawValue) else {
            return false
        }
        
        return (1920 ... 2002).contains(year)
    }
    
    var isIssueYearValid: Bool {
        guard let rawValue = valuesByField[.issueYear], rawValue.count == 4 else {
            return false
        }
        
        guard let year = Int(rawValue) else {
            return false
        }
        
        return (2010 ... 2020).contains(year)
    }
    
    var isExpirationYearValid: Bool {
        guard let rawValue = valuesByField[.expirationYear], rawValue.count == 4 else {
            return false
        }
        
        guard let year = Int(rawValue) else {
            return false
        }
        
        return (2020 ... 2030).contains(year)
    }
    
    var isHeightValid: Bool {
        guard let rawValue = valuesByField[.height] else {
            return false
        }
        
        guard rawValue.count >= 3 else {
            return false
        }
        
        let unitRawValue = String(rawValue.suffix(2))
        guard let unit = LengthUnit(rawValue: unitRawValue) else {
            return false
        }
        
        let remaining = String(rawValue.dropLast(2))
        guard let value = Int(remaining) else {
            return false
        }
        
        return unit.isValueValid(value)
    }
    
    var isHairColorValid: Bool {
        guard let rawValue = valuesByField[.hairColor] else {
            return false
        }
        
        guard rawValue.count == 7 else {
            return false
        }
        
        guard rawValue.first == "#" else {
            return false
        }
        
        let remaining = rawValue.dropFirst()
        let validCharacters = Set("0123456789abcdef")
        return remaining.allSatisfy({ validCharacters.contains($0) })
    }
    
    var isEyeColorValid: Bool {
        guard let rawValue = valuesByField[.eyeColor] else {
            return false
        }
        
        return EyeColor(rawValue: rawValue) != nil
    }
    
    var isPassportIDValid: Bool {
        guard let rawValue = valuesByField[.passportID] else {
            return false
        }
        
        guard rawValue.count == 9 else {
            return false
        }
        
        return rawValue.allSatisfy({ $0.isNumber })
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

enum EyeColor: String {
    case amber = "amb"
    case blue = "blu"
    case brown = "brn"
    case grey = "gry"
    case green = "grn"
    case hazel = "hzl"
    case other = "oth"
}

enum LengthUnit: String {
    case centimeters = "cm"
    case inches = "in"
    
    func isValueValid(_ value: Int) -> Bool {
        switch self {
        case .centimeters:
            return (150 ... 193).contains(value)
            
        case .inches:
            return (59 ... 76).contains(value)
            
        }
    }
}
