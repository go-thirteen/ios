//
//  Choice.swift
//  Thirteen
//
//  Created by Wilhelm Thieme on 20/03/2020.
//  Copyright © 2020 Wilhelm Thieme. All rights reserved.
//

import Foundation

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
