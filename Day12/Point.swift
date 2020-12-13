//
//  Point.swift
//  Day12
//
//  Created by Marc-Antoine Malépart on 2020-12-12.
//

import Foundation

struct Point {
    var x: Float
    var y: Float
    
    static let zero = Point(x: 0, y: 0)
    
    func manhattanDistance(to other: Point) -> Float {
        abs(other.x - x) + abs(other.y - y)
    }
    
    func applying(_ transform: Transform2D) -> Point {
        var point = self
        point.apply(transform)
        return point
    }
    
    mutating func apply(_ transform: Transform2D) {
        let newX = transform.a * x + transform.c * y + transform.tx
        let newY = transform.b * x + transform.d * y + transform.ty
        
        self.x = newX
        self.y = newY
    }
}

extension Point {
    init(x: Int, y: Int) {
        self.x = Float(x)
        self.y = Float(y)
    }
}

extension Point: Hashable {}

extension Point: Equatable {}

struct Transform2D {
    var a: Float
    var b: Float
    var c: Float
    var d: Float
    var tx: Float
    var ty: Float
    
    static let identity = Transform2D(
        a: 1,
        b: 0,
        c: 0,
        d: 1,
        tx: 0,
        ty: 0
    )
    
    static func rotation(by angle: Float) -> Transform2D {
        let sine = sin(angle)
        let cosine = cos(angle)
        
        return Transform2D(
            a: cosine,
            b: sine,
            c: -sine,
            d: cosine,
            tx: 0,
            ty: 0
        )
    }
    
    static func rotation(by angle: Measurement<UnitAngle>) -> Transform2D {
        let radians = angle.converted(to: .radians)
        return rotation(by: Float(radians.value))
    }
    
    static func translation(x: Float, y: Float) -> Transform2D {
        Transform2D(
            a: 1,
            b: 0,
            c: 0,
            d: 1,
            tx: x,
            ty: y
        )
    }
}

extension Transform2D: Equatable {}
