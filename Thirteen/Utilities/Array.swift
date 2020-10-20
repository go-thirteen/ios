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
