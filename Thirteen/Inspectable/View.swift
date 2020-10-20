//
//  View.swift
//  EersteKamer
//
//  Created by Wilhelm Thieme on 09/06/2020.
//  Copyright © 2020 Sogeti Nederland B.V. All rights reserved.
//

import UIKit

extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get { return layer.cornerRadius }
        set(value) { layer.cornerRadius = value }
    }

    @IBInspectable var borderColor: UIColor? {
        get { if let cg = layer.borderColor { return UIColor(cgColor: cg) }; return nil }
        set(value) { layer.borderColor = value?.cgColor }
    }

    @IBInspectable var borderWidth: CGFloat {
        get { return layer.borderWidth }
        set(value) { layer.borderWidth = value }
    }
    
    @IBInspectable var masksToBounds: Bool {
        get { return layer.masksToBounds }
        set(value) { layer.masksToBounds = value }
    }
}
