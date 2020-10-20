//
//  Square.swift
//  Thirteen
//
//  Created by Wilhelm Thieme on 24/03/2020.
//  Copyright © 2020 Wilhelm Thieme. All rights reserved.
//

import Foundation

class Square: Codable {
    var value: Int
    var rank: Int
    
    init(value v: Int = 0, rank r: Int = 0) {
        value = v
        rank = r
    }
}
