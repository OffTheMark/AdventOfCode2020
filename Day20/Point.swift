//
//  Point.swift
//  Day20
//
//  Created by Marc-Antoine Malépart on 2020-12-20.
//

import Foundation

struct Point {
    var x: Double
    var y: Double
    
    static let zero = Point(x: 0, y: 0)
    
    func manhattanDistance(to other: Point) -> Double {
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
        self.x = Double(x)
        self.y = Double(y)
    }
}

extension Point: Hashable {}

extension Point: Equatable {}

struct AffineTransform {
    var a: Double
    var b: Double
    var c: Double
    var d: Double
    var tx: Double
    var ty: Double
    
    func concatenating(_ other: AffineTransform) -> AffineTransform {
        AffineTransform(
            a: a * other.a + c * other.b,
            b: b * other.a + d * other.b,
            c: a * other.c + c * other.d,
            d: b * other.c + d * other.d,
            tx: a * other.tx + c * other.ty + tx * 1,
            ty: b * other.tx + d * other.ty + ty * 1
        )
    }
    
    func rotated(by angle: Double) -> AffineTransform {
        concatenating(.rotation(by: angle))
    }
    
    func rotated(by angle: Measurement<UnitAngle>) -> AffineTransform {
        concatenating(.rotation(by: angle))
    }
    
    func translatedBy(x: Double, y: Double) -> AffineTransform {
        concatenating(.translation(x: x, y: y))
    }
    
    func scaledBy(x: Double, y: Double) -> AffineTransform {
        concatenating(.scaleBy(x: x, y: y))
    }
    
    static let identity = AffineTransform(
        a: 1,
        b: 0,
        c: 0,
        d: 1,
        tx: 0,
        ty: 0
    )
    
    static func rotation(by angle: Double) -> AffineTransform {
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
        return rotation(by: radians.value)
    }
    
    static func translation(x: Double, y: Double) -> AffineTransform {
        AffineTransform(
            a: 1,
            b: 0,
            c: 0,
            d: 1,
            tx: x,
            ty: y
        )
    }
    
    static func scaleBy(x: Double, y: Double) -> AffineTransform {
        AffineTransform(
            a: x,
            b: 0,
            c: 0,
            d: y,
            tx: 0,
            ty: 0
        )
    }
}

extension AffineTransform: Equatable {}

struct Size {
    var width: Double
    var height: Double
}

extension Size {
    init(width: Int, height: Int) {
        self.width = Double(width)
        self.height = Double(height)
    }
}
