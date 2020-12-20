//
//  Tile.swift
//  Day20
//
//  Created by Marc-Antoine Malépart on 2020-12-20.
//

import Foundation

struct Tile {
    let identifier: Int
    let contents: [Point: Character]
    
    let origin: Point = .zero
    let size: Size
    
    var topLeft: Point { origin }
    
    var topRight: Point {
        var point = origin
        point.x += size.width
        return point
    }
    
    var bottomLeft: Point {
        var point = origin
        point.y += size.height
        return point
    }
    
    var bottomRight: Point {
        var point = origin
        point.x += size.width
        point.y += size.height
        return point
    }
    
    var topEdge: String {
        return (0 ... Int(size.width)).reduce(into: "", { edge, offset in
            var point = origin
            point.x += Double(offset)
            edge.append(contents[point, default: "."])
        })
    }
    
    var bottomEdge: String {
        return (0 ... Int(size.width)).reduce(into: "", { edge, offset in
            var point = bottomLeft
            point.x += Double(offset)
            edge.append(contents[point, default: "."])
        })
    }
    
    var leftEdge: String {
        return (0 ... Int(size.height)).reduce(into: "", { edge, offset in
            var point = origin
            point.y += Double(offset)
            edge.append(contents[point, default: "."])
        })
    }
    
    var rightEdge: String {
        return (0 ... Int(size.height)).reduce(into: "", { edge, offset in
            var point = topRight
            point.y += Double(offset)
            edge.append(contents[point, default: "."])
        })
    }
    
    var allEdges: [String] { [topEdge, leftEdge, bottomEdge, rightEdge]  }
}

extension Tile {
    init?(rawValue: String) {
        var lines = rawValue.components(separatedBy: .newlines)
        guard lines.count > 1 else {
            return nil
        }
        
        let firstLine = lines.removeFirst()
        
        guard let identifier = Int(firstLine.removingPrefix("Tile ").removingSuffix(":")) else {
            return nil
        }
        
        var contents = [Point: Character]()
        
        var maxX = 0
        var maxY = 0
        for (y, line) in lines.enumerated() {
            for (x, character) in line.enumerated() {
                let point = Point(x: x, y: y)
                contents[point] = character
                
                maxX = max(maxX, x)
            }
            
            maxY = max(maxY, y)
        }
        
        self.identifier = identifier
        self.contents = contents
        self.size = Size(width: maxX, height: maxY)
    }
}

extension String {
    func removingPrefix(_ prefix: String) -> String {
        guard self.hasPrefix(prefix) else {
            return self
        }
        
        return String(self.dropFirst(prefix.count))
    }
    
    func removingSuffix(_ suffix: String) -> String {
        guard self.hasSuffix(suffix) else {
            return self
        }
        
        return String(self.dropLast(suffix.count))
    }
}
