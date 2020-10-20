//
//  ClassicBoard.swift
//  Thirteen
//
//  Created by Wilhelm Thieme on 20/10/2020.
//  Copyright © 2020 Wilhelm Thieme. All rights reserved.
//

import Foundation

class ClassicBoard: Board {
    override class var rows: Int { return 3 }
    override class var columns: Int { return 3 }
    
    override func reduce(_ values: [IndexPath]) -> Int {
        return values.compactMap({ self[$0]?.value }).reduce(0, +)
    }

    override func newValue() -> Int {
        let random = Float.random(in: 0..<1)
        let value = round(pow(7, random)) + 2
        return Int(value)
    }
    
    override func score(for value: Int) -> Int {
        return value
    }
    
    override var isGameOver: Bool {
        let top = Self.indexes.map { (self[$0]?.value ?? 13) + (self[$0-|1]?.value ?? 13) }
        let left = Self.indexes.map { (self[$0]?.value ?? 13) + (self[$0--1]?.value ?? 13) }
        let right = Self.indexes.map { (self[$0]?.value ?? 13) + (self[$0+-1]?.value ?? 13) }
        let bottom = Self.indexes.map { (self[$0]?.value ?? 13) + (self[$0+|1]?.value ?? 13) }
        return !(top + left + right + bottom).contains { $0 <= 13 }
    }
    
    override func canAdd(indexPath: IndexPath, to selection: [IndexPath]) -> Bool {
        return selection.isLastPosition([.orthogonal], to: indexPath) && reduce(selection + [indexPath]) <= 13
    }
    
    
}
