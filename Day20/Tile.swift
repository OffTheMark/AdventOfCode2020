//
//  Tile.swift
//  Day20
//
//  Created by Marc-Antoine Malépart on 2020-12-20.
//

import Foundation

struct Tile {
    let identifier: Int
    let contents: [String]
    
    var topEdge: String { contents.first! }
    var bottomEdge: String { contents.last! }
    var leftEdge: String { String(contents.map({ $0.first! })) }
    var rightEdge: String { String(contents.map({ $0.last! })) }
    
    var allEdges: [String] { [topEdge, rightEdge, bottomEdge, leftEdge] }
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
        
        self.identifier = identifier
        self.contents = lines
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
