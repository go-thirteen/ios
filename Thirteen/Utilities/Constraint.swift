//
//  LayoutConstraint.swift
//  Thirteen
//
//  Created by Wilhelm Thieme on 20/03/2020.
//  Copyright © 2020 Wilhelm Thieme. All rights reserved.
//

import UIKit

extension NSLayoutConstraint {
    
    @discardableResult func activated(_ prio: UILayoutPriority = .required) -> NSLayoutConstraint {
        priority = prio
        isActive = true
        return self
    }
    
}
