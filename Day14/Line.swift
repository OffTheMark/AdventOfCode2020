//
//  Line.swift
//  Day14
//
//  Created by Marc-Antoine Malépart on 2020-12-14.
//

import Foundation

extension Int {
    mutating func setBit(at position: Int) {
        self |= 1 << position
    }
    
    mutating func clearBit(at position: Int) {
        self &= ~(1 << position)
    }
    
    func settingBit(at position: Int) -> Int {
        return self | 1 << position
    }
    
    func clearingBit(at position: Int) -> Int {
        return self & ~(1 << position)
    }
}

enum Version1 {
    enum BitOperation: Character {
        case clear = "0"
        case set = "1"
        case none = "x"
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
            switch operation {
            case .set:
                value.setBit(at: position)
                
            case .clear:
                value.clearBit(at: position)
                
            case .none:
                break
            }
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
            result.setBit(at: position)
        })
        
        var addresses = [baseAddress]
        
        for position in floatingPositions {
            var newAddresses = [Int]()
            
            for address in addresses {
                newAddresses += [
                    address.clearingBit(at: position),
                    address.settingBit(at: position)
                ]
            }
            
            addresses = newAddresses
        }
        
        return addresses
    }
}
