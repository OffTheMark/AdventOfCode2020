//
//  BoardingPass.swift
//  Day5
//
//  Created by Marc-Antoine Malépart on 2020-12-05.
//

import Foundation

struct BoardingPass {
    let rawValue: String
    let rowDirections: [RowDirection]
    let columnDirections: [ColumnDirection]
    
    init?(rawValue: String) {
        let rowDirections = rawValue.prefix(7).compactMap({ RowDirection(rawValue: $0) })
        
        guard rowDirections.count == 7 else {
            return nil
        }
        
        let columnDirections = rawValue.suffix(3).compactMap({ ColumnDirection(rawValue: $0) })
        
        guard columnDirections.count == 3 else {
            return nil
        }
        
        self.rawValue = rawValue
        self.rowDirections = rowDirections
        self.columnDirections = columnDirections
    }
    
    func identifier() -> Int {
        var validRows = Self.rowRange
        
        for direction in rowDirections {
            let halfLength = validRows.count / 2
            
            switch direction {
            case .front:
                validRows = validRows.lowerBound ..< (validRows.lowerBound + halfLength)
                
            case .back:
                validRows = (validRows.lowerBound + halfLength) ..< validRows.upperBound
            }
        }
        
        var validColumns = Self.columnRange
        for direction in columnDirections {
            let halfLength = validColumns.count / 2
            
            switch direction {
            case .left:
                validColumns = validColumns.lowerBound ..< (validColumns.lowerBound + halfLength)
                
            case .right:
                validColumns = (validColumns.lowerBound + halfLength) ..< validColumns.upperBound
            }
        }
        
        let row = validRows.first!
        let column = validColumns.first!
        
        return row * 8 + column
    }
    
    static let rowRange: Range<Int> = 0 ..< 128
    static let columnRange: Range<Int> = 0 ..< 8
}

enum RowDirection: Character {
    case front = "F"
    case back = "B"
}

enum ColumnDirection: Character {
    case left = "L"
    case right = "R"
}
