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
    
    func applying(_ transform: AffineTransform) -> Point {
        var point = self
        point.apply(transform)
        return point
    }
    
    mutating func apply(_ transform: AffineTransform) {
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

struct AffineTransform {
    var a: Float
    var b: Float
    var c: Float
    var d: Float
    var tx: Float
    var ty: Float
    
    static let identity = AffineTransform(
        a: 1,
        b: 0,
        c: 0,
        d: 1,
        tx: 0,
        ty: 0
    )
    
    static func rotation(by angle: Float) -> AffineTransform {
        let sine = sin(angle)
        let cosine = cos(angle)
        
        return AffineTransform(
            a: cosine,
            b: sine,
            c: -sine,
            d: cosine,
            tx: 0,
            ty: 0
        )
    }
    
    static func rotation(by angle: Measurement<UnitAngle>) -> AffineTransform {
        let radians = angle.converted(to: .radians)
        return rotation(by: Float(radians.value))
    }
    
    static func translation(x: Float, y: Float) -> AffineTransform {
        AffineTransform(
            a: 1,
            b: 0,
            c: 0,
            d: 1,
            tx: x,
            ty: y
        )
    }
}

extension AffineTransform: Equatable {}
