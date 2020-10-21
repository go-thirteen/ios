//
//  HardcoreBoard.swift
//  Thirteen
//
//  Created by Wilhelm Thieme on 20/10/2020.
//  Copyright © 2020 Wilhelm Thieme. All rights reserved.
//

import Foundation

fileprivate let options: [(Float, Int)] = [(0.05, 1), (0.05, 2), (0.05, 3), (0.1, 4), (0.1, 5), (0.2, 6), (0.05, 7), (0.05, 8), (0.2, 9), (0.1, 10), (0.05, 11)]

class HardcoreBoard: ClassicBoard {

    override func newValue() -> Int {
        return Choice.choose(from: options) ?? 0
    }
}
