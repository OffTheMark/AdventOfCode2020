//
//  Line.swift
//  Day14
//
//  Created by Marc-Antoine Malépart on 2020-12-14.
//

import Foundation

enum Version1 {
    enum BitOperation: Character {
        case clear = "0"
        case set = "1"
        case none = "x"
        
        func apply(toPosition position: Int, ofValue value: Int) -> Int {
            switch self {
            case .none:
                return value
                
            case .clear:
                return value ^ ((-0 ^ value) & (1 << position))
                
            case .set:
                return value ^ ((-1 ^ value) & (1 << position))
            }
        }
    }
    
    enum Line {
        case mask([Int: BitOperation])
        case write(address: Int, value: Int)
        
        init?(rawValue: String) {
            let parts = rawValue.components(separatedBy: " = ")
            guard parts.count == 2 else {
                return nil
            }
            
            switch parts[0] {
            case "mask":
                let mask: [Int: BitOperation] = parts[1].enumerated().reduce(into: [:], { result, element in
                    let (index, character) = element
                    
                    guard let operation = Version1.BitOperation(rawValue: character) else {
                        return
                    }
                    
                    result[35 - index] = operation
                })
                self = .mask(mask)
                
            case let part where part.starts(with: "mem"):
                let indexRawValue = part.components(separatedBy: .init(charactersIn: "[]"))[1]
                
                guard let address = Int(indexRawValue) else {
                    return nil
                }
                
                guard let value = Int(parts[1]) else {
                    return nil
                }
                
                self = .write(address: address, value: value)
                
            default:
                return nil
            }
        }
    }
}

extension Dictionary where Key == Int, Value == Version1.BitOperation {
    func apply(to value: Int) -> Int {
        var value = value
        
        for (position, operation) in self {
            value = operation.apply(toPosition: position, ofValue: value)
        }
        
        return value
    }
}

enum Version2 {
    enum BitOperation: Character {
        case unchanged = "0"
        case overwritten = "1"
        case floating = "X"
    }
    
    enum Line {
        case mask([Int: BitOperation])
        case write(address: Int, value: Int)
        
        init?(rawValue: String) {
            let parts = rawValue.components(separatedBy: " = ")
            
            guard parts.count == 2 else {
                return nil
            }
            
            switch parts[0] {
            case "mask":
                let mask: [Int: BitOperation] = parts[1].enumerated().reduce(into: [:], { result, element in
                    let (index, character) = element
                    
                    guard let operation = BitOperation(rawValue: character) else {
                        return
                    }
                    
                    result[35 - index] = operation
                })
                self = .mask(mask)
                
            case let part where part.starts(with: "mem"):
                let indexRawValue = part.components(separatedBy: .init(charactersIn: "[]"))[1]
                
                guard let address = Int(indexRawValue) else {
                    return nil
                }
                
                guard let value = Int(parts[1]) else {
                    return nil
                }
                
                self = .write(address: address, value: value)
                
            default:
                return nil
            }
        }
    }
}

extension Dictionary where Key == Int, Value == Version2.BitOperation {
    func addresses(from baseAddress: Int) -> [Int] {
        var overwrittenPositions = [Int]()
        var floatingPositions = [Int]()
        
        for (position, operation) in self {
            switch operation {
            case .overwritten:
                overwrittenPositions.append(position)
                
            case .floating:
                floatingPositions.append(position)
                
            case .unchanged:
                continue
            }
        }
        
        let baseAddress = overwrittenPositions.reduce(into: baseAddress, { result, position in
            result ^= ((-1 ^ result) & (1 << position))
        })
        
        var addresses = [baseAddress]
        
        for position in floatingPositions {
            var clearedAddresses = [Int]()
            var setAddresses = [Int]()
            
            for address in addresses {
                clearedAddresses.append(address ^ ((-0 ^ address) & (1 << position)))
                setAddresses.append(address ^ ((-1 ^ address) & (1 << position)))
            }
            
            addresses = clearedAddresses + setAddresses
        }
        
        return addresses
    }
}
