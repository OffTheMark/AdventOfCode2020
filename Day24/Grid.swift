//
//  Grid.swift
//  Day24
//
//  Created by Marc-Antoine Malépart on 2020-12-24.
//

import Foundation

struct CubePoint {
    var x: Int
    var y: Int
    var z: Int
    
    static let zero = CubePoint(x: 0, y: 0, z: 0)
}

extension CubePoint: Hashable {}

extension CubePoint {
    static func += (lhs: inout CubePoint, rhs: CubeVector) {
        lhs.x += rhs.deltaX
        lhs.y += rhs.deltaY
        lhs.z += rhs.deltaZ
    }
    
    static func + (lhs: CubePoint, rhs: CubeVector) -> CubePoint {
        CubePoint(
            x: lhs.x + rhs.deltaX,
            y: lhs.y + rhs.deltaY,
            z: lhs.z + rhs.deltaZ
        )
    }
}

struct CubeVector {
    var deltaX: Int
    var deltaY: Int
    var deltaZ: Int
    
    static let zero = CubeVector(deltaX: 0, deltaY: 0, deltaZ: 0)
}

extension CubeVector {
    static func += (lhs: inout CubeVector, rhs: CubeVector) {
        lhs.deltaX += rhs.deltaX
        lhs.deltaY += rhs.deltaY
        lhs.deltaZ += rhs.deltaZ
    }
}

enum Direction: String {
    case east = "e"
    case southEast = "se"
    case southWest = "sw"
    case west = "w"
    case northWest = "nw"
    case northEast = "ne"
    
    var vector: CubeVector {
        switch self {
        case .east:
            return CubeVector(deltaX: 1, deltaY: -1, deltaZ: 0)
            
        case .southEast:
            return CubeVector(deltaX: 0, deltaY: -1, deltaZ: 1)
            
        case .southWest:
            return CubeVector(deltaX: -1, deltaY: 0, deltaZ: 1)
            
        case .west:
            return CubeVector(deltaX: -1, deltaY: 1, deltaZ: 0)
            
        case .northWest:
            return CubeVector(deltaX: 0, deltaY: 1, deltaZ: -1)
            
        case .northEast:
            return CubeVector(deltaX: 1, deltaY: 0, deltaZ: -1)
        }
    }
}

enum Tile {
    case white
    case black
    
    mutating func flip() {
        switch self {
        case .white:
            self = .black
            
        case .black:
            self = .white
        }
    }
}
