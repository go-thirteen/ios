//
//  ActionSheet.swift
//  Beatz
//
//  Created by Wilhelm Thieme on 11/10/2020.
//  Copyright © 2020 wjthieme. All rights reserved.
//

import UIKit

class AlertController: UIAlertController {
    
    //FIXME: Fixes a constraint conflict bug
    override func viewDidLoad() {
        super.viewDidLoad()
        for subview in self.view.subviews {
            for constraint in subview.constraints {
                if constraint.firstAttribute == .width && constraint.constant == -16 {
                    constraint.priority = .defaultHigh
                }
            }
        }
        if let popover = popoverPresentationController, let root = UIApplication.shared.delegate?.window??.rootViewController {
            popover.sourceView = root.view
            popover.sourceRect = CGRect(x: root.view.bounds.midX, y: root.view.bounds.midY, width: 0, height: 0)
            popover.permittedArrowDirections = []
        }
    }
    
    //FIXME: Fixes a bug that tint is not set correctly
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.view.tintColor = view.tintColor
    }
    
}
