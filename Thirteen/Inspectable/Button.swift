//
//  Button.swift
//  EersteKamer
//
//  Created by Wilhelm Thieme on 09/06/2020.
//  Copyright © 2020 Sogeti Nederland B.V. All rights reserved.
//

import UIKit

extension UIButton {
    @IBInspectable var localized: Bool {
        get { return false }
        set(value) {
            guard let key = title(for: .normal), value else { return }
            setTitle(localizedString(key), for: .normal)
        }
    }
}
