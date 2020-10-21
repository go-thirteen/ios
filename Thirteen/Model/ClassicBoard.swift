//
//  ClassicBoard.swift
//  Thirteen
//
//  Created by Wilhelm Thieme on 20/10/2020.
//  Copyright © 2020 Wilhelm Thieme. All rights reserved.
//

import Foundation

fileprivate let options: [(Float, Int)] = [(0.1, 1), (0.1, 2), (0.2, 3), (0.2, 4), (0.1, 5), (0.1, 6), (0.1, 7), (0.05, 8), (0.02, 9), (0.02, 10), (0.01, 11)]

class ClassicBoard: Board {
    override class var rows: Int { return 3 }
    override class var columns: Int { return 3 }
    
    override func reduce(_ values: [IndexPath]) -> Int {
        return values.compactMap({ self[$0]?.value }).reduce(0, +)
    }

    override func newValue() -> Int {
        return Choice.choose(from: options) ?? 0
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
