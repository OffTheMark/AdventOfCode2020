//
//  Grid.swift
//  Day17
//
//  Created by Marc-Antoine Malépart on 2020-12-17.
//

import Foundation
import Algorithms

struct Grid3D {
    var contents: [Point3D: Cube]
    
    init(contents: [Point3D: Cube]) {
        self.contents = contents
    }
    
    subscript(point: Point3D) -> Cube {
        set {
            contents[point] = newValue
        }
        get {
            contents[point, default: .inactive]
        }
    }
    
    mutating func merge(_ other: Grid3D) {
        contents.merge(other.contents, uniquingKeysWith: { _, right in right })
    }
}

extension Grid3D {
    init(lines: [String]) {
        var contents = [Point3D: Cube]()
        
        for (x, line) in lines.enumerated() {
            for (y, character) in line.enumerated() {
                guard let cube = Cube(rawValue: character) else {
                    continue
                }
                
                let point = Point3D(x: x, y: y, z: 0)
                contents[point] = cube
            }
        }
        
        self.init(contents: contents)
    }
}

struct Point3D {
    var x: Int
    var y: Int
    var z: Int
    
    func neighbors() -> Set<Point3D> {
        let delta = -1 ... 1
        
        let coordinates = product(product(delta, delta), delta)
        
        return coordinates.reduce(into: [], { result, element in
            let ((deltaX, deltaY), deltaZ) = element
            
            if [deltaX, deltaY, deltaZ].allSatisfy({ $0 == 0 }) {
                return
            }
            
            let neighbor = Point3D(
                x: x + deltaX,
                y: y + deltaY,
                z: z + deltaZ
            )
            result.insert(neighbor)
        })
    }
}

extension Point3D: Hashable {}

extension Point3D: Equatable {}

struct Grid4D {
    var contents: [Point4D: Cube]
    
    init(contents: [Point4D: Cube]) {
        self.contents = contents
    }
    
    subscript(point: Point4D) -> Cube {
        set {
            contents[point] = newValue
        }
        get {
            contents[point, default: .inactive]
        }
    }
    
    mutating func merge(_ other: Grid4D) {
        contents.merge(other.contents, uniquingKeysWith: { _, right in right })
    }
}

extension Grid4D {
    init(lines: [String]) {
        var contents = [Point4D: Cube]()
        
        for (x, line) in lines.enumerated() {
            for (y, character) in line.enumerated() {
                guard let cube = Cube(rawValue: character) else {
                    continue
                }
                
                let point = Point4D(x: x, y: y, z: 0, w: 0)
                contents[point] = cube
            }
        }
        
        self.init(contents: contents)
    }
}

struct Point4D {
    var x: Int
    var y: Int
    var z: Int
    var w: Int
    
    func neighbors() -> Set<Point4D> {
        let delta = -1 ... 1
        
        let coordinates = product(product(product(delta, delta), delta), delta)
        
        return coordinates.reduce(into: [], { result, element in
            let (((deltaX, deltaY), deltaZ), deltaW) = element
            
            if [deltaX, deltaY, deltaZ, deltaW].allSatisfy({ $0 == 0 }) {
                return
            }
            
            let neighbor = Point4D(
                x: x + deltaX,
                y: y + deltaY,
                z: z + deltaZ,
                w: w + deltaW
            )
            result.insert(neighbor)
        })
    }
}

extension Point4D: Hashable {}

extension Point4D: Equatable {}

enum Cube: Character {
    case active = "#"
    case inactive = "."
}
