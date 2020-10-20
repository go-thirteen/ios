//
//  HardcoreBoard.swift
//  Thirteen
//
//  Created by Wilhelm Thieme on 20/10/2020.
//  Copyright © 2020 Wilhelm Thieme. All rights reserved.
//

import Foundation

class HardcoreBoard: ClassicBoard {

    override func newValue() -> Int {
        let random = Float.random(in: 0..<1)
        let value = round(pow(8, random)) + 3
        return Int(value)
    }
}
