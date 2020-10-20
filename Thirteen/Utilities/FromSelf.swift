//
//  FromSelf.swift
//  Thirteen
//
//  Created by Wilhelm Thieme on 20/10/2020.
//  Copyright © 2020 Wilhelm Thieme. All rights reserved.
//

import Foundation

protocol FromSelf {
    init(from itself: Self)
    
}

extension FromSelf {
    init(from itself: Self) {
        self = itself
    }
}
