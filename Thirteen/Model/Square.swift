//
//  Square.swift
//  Thirteen
//
//  Created by Wilhelm Thieme on 24/03/2020.
//  Copyright © 2020 Wilhelm Thieme. All rights reserved.
//

import Foundation

struct Square: Codable {
    var value: Int
    var rank: Int
    
    init(value v: Int = 0, rank r: Int = 0) {
        value = v
        rank = r
    }

    var isEmpty: Bool {
        return value == 0
    }
    
    var isCompleted: Bool {
        return value == 13
    }
    
    var isGameover: Bool {
        return value > 13
    }
}
