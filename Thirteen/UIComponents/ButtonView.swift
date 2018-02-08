//
//  ButtonView.swift
//  13!
//
//  Created by Wilhelm Thieme on 10/16/17.
//  Copyright © 2017 Wilhelm Thieme. All rights reserved.
//

import SpriteKit

class ButtonView : SKShapeNode {
    
    enum ButtonViewType: Int {
        case TouchUpInside = 1,
        TouchDown, TouchUp
    }
    
    var isEnabled: Bool = true {
        didSet {
            fillColor = isEnabled ? defaultColor : disabledColor
        }
    }
    
    var defaultColor: SKColor {
        didSet {
            selectedColor = defaultColor.withAlphaComponent(0.5)
            if isEnabled {
                fillColor = isSelected ? selectedColor : defaultColor
            }
        }
    }
    var textColor: SKColor {
        didSet {
            selectedTextColor = inverse(color: textColor)
            label.fontColor = isSelected ? selectedTextColor : textColor
        }
    }
    var title: String {
        didSet {
            label.text = title
        }
    }
    private var label: SKLabelNode = SKLabelNode(fontNamed: "Helvetica")
    
    private var isSelected: Bool = false {
        didSet {
            fillColor = isSelected ? selectedColor : defaultColor
            label.fontColor = isSelected ? selectedTextColor : textColor
        }
    }
    
    private var selectedColor: SKColor
    private var disabledColor: SKColor
    private var selectedTextColor: SKColor
    
    private var actionTouchUpInside: Selector?
    private var actionTouchUp: Selector?
    private var actionTouchDown: Selector?
    private weak var targetTouchUpInside: AnyObject?
    private weak var targetTouchUp: AnyObject?
    private weak var targetTouchDown: AnyObject?
    
    required init(coder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    init(rect: CGRect, cornerRadius: CGFloat, color : SKColor, text: String) {
        defaultColor = color
        selectedColor = defaultColor.withAlphaComponent(0.5)
        disabledColor = SKColor.gray
        textColor = SKColor.darkGray
        selectedTextColor = SKColor.white
        title = text
        
        super.init()
        
        path = CGPath(roundedRect: rect, cornerWidth: cornerRadius, cornerHeight: cornerRadius, transform: nil)
        fillColor = defaultColor
        isUserInteractionEnabled = true
        
        label.verticalAlignmentMode = .center
        label.horizontalAlignmentMode = .center
        label.position = CGPoint(x: rect.midX, y: rect.midY)
        label.fontColor = textColor
        label.text = title
        //textSize dependant on buttonsize
        addChild(label)
    }
    
    func setButtonAction(target: AnyObject, triggerEvent event: ButtonViewType, action: Selector) {
        switch (event) {
        case .TouchUpInside:
            targetTouchUpInside = target
            actionTouchUpInside = action
        case .TouchDown:
            targetTouchDown = target
            actionTouchDown = action
        case .TouchUp:
            targetTouchUp = target
            actionTouchUp = action
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (!isEnabled) {
            return
        }
        isSelected = true
        if (targetTouchDown != nil && targetTouchDown!.responds(to: actionTouchDown!)) {
            UIApplication.shared.sendAction(actionTouchDown!, to: targetTouchDown, from: self, for: nil)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if (!isEnabled) {
            return
        }
        
        let touch: AnyObject! = touches.first
        let touchLocation = touch.location(in: parent!)
        
        if (frame.contains(touchLocation)) {
            isSelected = true
        } else {
            isSelected = false
        }
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (!isEnabled) {
            return
        }
        
        isSelected = false
        
        if (targetTouchUpInside != nil && targetTouchUpInside!.responds(to: actionTouchUpInside!)) {
            let touch: AnyObject! = touches.first
            let touchLocation = touch.location(in: parent!)
            
            if (frame.contains(touchLocation) ) {
                UIApplication.shared.sendAction(actionTouchUpInside!, to: targetTouchUpInside, from: self, for: nil)
            }
            
        }
        
        if (targetTouchUp != nil && targetTouchUp!.responds(to: actionTouchUp!)) {
            UIApplication.shared.sendAction(actionTouchUp!, to: targetTouchUp, from: self, for: nil)
        }
    }
    
    private func inverse(color : SKColor) -> SKColor {
        var blue : CGFloat = 0
        var green : CGFloat = 0
        var alpha : CGFloat = 0
        var red : CGFloat = 0
        color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return SKColor(red: 1-red, green: 1-green, blue: 1-blue, alpha: 1)
    }
    
    
}
