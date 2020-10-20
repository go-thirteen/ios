//
//  Label.swift
//  EersteKamer
//
//  Created by Wilhelm Thieme on 09/06/2020.
//  Copyright © 2020 Sogeti Nederland B.V. All rights reserved.
//

import UIKit

extension UILabel {
    @IBInspectable var localized: Bool {
        get { return false }
        set(value) {
            guard let key = text, value else { return }
            text = localizedString(key)
        }
    }
    
    override open var canBecomeFirstResponder: Bool { return true }
}
