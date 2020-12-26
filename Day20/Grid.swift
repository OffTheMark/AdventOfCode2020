//
//  Grid.swift
//  Day20
//
//  Created by Marc-Antoine Malépart on 2020-12-26.
//

import Foundation
import Algorithms

struct Grid {
    let contents: [Point: Character]
    let size: Size
    
    var center: Point {
        Point(
            x: size.width / 2,
            y: size.height / 2
        )
    }
    
    func rotatedLeft() -> Grid {
        let center = self.center
        let transform = AffineTransform.translation(x: center.x, y: center.y)
            .rotated(by: .init(value: -90, unit: .degrees))
            .translatedBy(x: -center.x, y: -center.y)
        
        let newContents: [Point: Character] = contents.reduce(into: [:], { result, element in
            let (point, character) = element
            let transformedPoint = point.applying(transform)
            result[transformedPoint] = character
        })
        
        return Grid(contents: newContents, size: size)
    }
    
    func flippedVertically() -> Grid {
        let center = self.center
        let transform = AffineTransform.translation(x: center.x, y: center.y)
            .scaledBy(x: 1, y: -1)
            .translatedBy(x: -center.x, y: -center.y)
        
        let newContents: [Point: Character] = contents.reduce(into: [:], { result, element in
            let (point, character) = element
            let transformedPoint = point.applying(transform)
            result[transformedPoint] = character
        })
        
        return Grid(contents: newContents, size: size)
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

extension Grid {
    init(assembledTiles: [[Tile]]) {
        var assembledLines = [String]()
        
        for lineOfTiles in assembledTiles {
            let height = lineOfTiles.map({ $0.contents.count }).max()!
            
            for lineInTile in 0 ..< height {
                let assembledLine = lineOfTiles.map({ $0.contents[lineInTile] }).joined()
                assembledLines.append(assembledLine)
            }
        }
        
        var contents = [Point: Character]()
        let height = assembledLines.count
        var width = 0
        for (rowIndex, row) in assembledLines.enumerated() {
            width = max(width, row.count)
            
            for (columnIndex, character) in row.enumerated() {
                let point = Point(x: columnIndex, y: rowIndex)
                contents[point] = character
            }
        }
        
        self.contents = contents
        self.size = Size(width: width, height: height)
    }
}

