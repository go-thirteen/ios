//
//  Array.swift
//  Thirteen
//
//  Created by Wilhelm Thieme on 20/10/2020.
//  Copyright © 2020 Wilhelm Thieme. All rights reserved.
//

import Foundation

extension Array {
    public subscript(safe index: Int) -> Element? {
        guard index >= 0, index < endIndex else {
            return nil
        }
        return self[index]
    }
}

class Choice {
    static func choose<T>(from options: [(prob: Float, elem: T)]) -> T? {
        let rand = Float.random(in: 0..<1)
        var lower: Float = 0
        var upper: Float = 0
        for option in options {
            upper += option.prob
            if rand >= lower && rand < upper {
                return option.elem
            }
            lower += option.prob
        }
        return nil
    }
}
