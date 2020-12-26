//
//  Tile.swift
//  Day20
//
//  Created by Marc-Antoine Malépart on 2020-12-20.
//

import Foundation
import Algorithms

struct Tile {
    let identifier: Int
    let contents: [String]
    
    var topEdge: String { contents.first! }
    var bottomEdge: String { contents.last! }
    var leftEdge: String { String(contents.map({ $0.first! })) }
    var rightEdge: String { String(contents.map({ $0.last! })) }
    
    var allEdges: [String] { [topEdge, rightEdge, bottomEdge, leftEdge] }
    
    func flippedVertically() -> Tile {
        let newContents = Array(self.contents.reversed())
        return Tile(identifier: identifier, contents: newContents)
    }
    
    func flippedHorizontally() -> Tile {
        let newContents = self.contents.map({ String($0.reversed()) })
        return Tile(identifier: identifier, contents: newContents)
    }
    
    func rotatedLeft() -> Tile {
        var newContents = [String]()
        let width = contents[0].count
        
        for columnIndex in (0 ..< width).reversed() {
            var newLine = ""
            
            for lineIndex in self.contents.indices {
                let line = self.contents[lineIndex]
                let stringIndex = line.index(line.startIndex, offsetBy: columnIndex)
                
                newLine.append(line[stringIndex])
            }
            
            newContents.append(newLine)
        }
        
        return Tile(identifier: identifier, contents: newContents)
    }
    
    var allArrangements: [Tile] {
        let arrangements = [
            self,
            self.rotatedLeft(),
            self.rotatedLeft().rotatedLeft(),
            self.rotatedLeft().rotatedLeft().rotatedLeft()
        ]
        
        return product([false, true], arrangements).map({ shouldFlip, tile in
            if shouldFlip == false {
                return tile
            }
            
            return tile.flippedVertically()
        })
    }
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

struct Grid {
    let contents: [String]
    
    func flippedVertically() -> Grid {
        let newContents = Array(self.contents.reversed())
        return Grid(contents: newContents)
    }
    
    func flippedHorizontally() -> Grid {
        let newContents = self.contents.map({ String($0.reversed()) })
        return Grid(contents: newContents)
    }
    
    func rotatedLeft() -> Grid {
        var newContents = [String]()
        let width = contents[0].count
        
        for columnIndex in (0 ..< width).reversed() {
            var newLine = ""
            
            for lineIndex in self.contents.indices {
                let line = self.contents[lineIndex]
                let stringIndex = line.index(line.startIndex, offsetBy: columnIndex)
                
                newLine.append(line[stringIndex])
            }
            
            newContents.append(newLine)
        }
        
        return Grid(contents: newContents)
    }
    
    var allArrangements: [Grid] {
        let arrangements = [
            self,
            self.rotatedLeft(),
            self.rotatedLeft().rotatedLeft(),
            self.rotatedLeft().rotatedLeft().rotatedLeft()
        ]
        
        return product([false, true], arrangements).map({ shouldFlip, grid in
            if shouldFlip == false {
                return grid
            }
            
            return grid.flippedVertically()
        })
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
