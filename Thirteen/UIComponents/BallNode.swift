//
//  BallNode.swift
//  13!
//
//  Created by Wilhelm Thieme on 10/16/17.
//  Copyright © 2017 Wilhelm Thieme. All rights reserved.
//

import SpriteKit

class BallNode : SKShapeNode {
    
    
    private var label = SKLabelNode()
    var title = "" {
        didSet {
            label.text = title
        }
    }
    
    var timesAdded : CGFloat = 1
    
    var isSelected: Bool = false {
        didSet {
            fillColor = isSelected ? selectedColor : defaultColor
            label.fontColor = isSelected ? selectedTextColor : textColor
        }
    }
    
    var value = 0 {
        didSet {
            if let op = oper {
                var string = "\(value)"
                if abs(value) == 6 || abs(value) == 9 || abs(value) == 66 || abs(value) == 69 || abs(value) == 96 || abs(value) == 99 {
                    string.append(".")
                }
                if value == 13 && op == .plus {
                    string.append("!")
                }
                if op == .multiply {
                    var multiply = "x"
                    multiply.append(string)
                    string = multiply
                }
                label.text = string
            }
        }
    }
    var oper: operators?
    
    enum operators {
        case plus, multiply, minus
    }
    
    required init(coder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    
    var defaultColor: SKColor {
        didSet {
            selectedColor = defaultColor.withAlphaComponent(0.5)
            fillColor = isSelected ? selectedColor : defaultColor
        }
    }
    var textColor: SKColor {
        didSet {
            selectedTextColor = inverse(color: textColor)
            label.fontColor = isSelected ? selectedTextColor : textColor
        }
    }
    
    private var selectedColor: SKColor
    private var selectedTextColor: SKColor
    
    init(size: CGFloat, position: CGPoint, color : SKColor) {
        
        self.defaultColor = color
        self.selectedColor = color.withAlphaComponent(0.5)
        self.textColor = SKColor.black
        self.selectedTextColor = SKColor.white
        
        super.init()
        
        fillColor = self.defaultColor
        
        let rect = CGRect(x: position.x, y: position.y, width: size, height: size)
        path = CGPath(roundedRect: rect, cornerWidth: size*0.5, cornerHeight: size*0.5, transform: nil)
        setPhysics()
        
        
        label.verticalAlignmentMode = .center
        label.horizontalAlignmentMode = .center
        label.position = CGPoint(x: rect.midX, y: rect.midY)
        label.fontColor = SKColor.black
        label.text = title
        //textSize dependant on buttonsize
        addChild(label)
    }
    
    func setPhysics() {
        let physics = SKPhysicsBody(polygonFrom: self.path!)
        physics.affectedByGravity = true
        physics.restitution = 0
        physics.linearDamping = 0.2
        physicsBody = physics
    }
    
    func resize(to: CGFloat, duration: TimeInterval) {
        let size = CGSize(width: to, height: to)
        let rect = CGRect(origin: self.position, size: size)
        path = CGPath(roundedRect: rect, cornerWidth: self.frame.width*0.5, cornerHeight: self.frame.height*0.5, transform: nil)
        setPhysics()
    }
    
    func resize(by: CGFloat, duration: TimeInterval) {
        let size = CGSize(width: self.frame.width*by, height: self.frame.height*by)
        let rect = CGRect(origin: self.position, size: size)
        path = CGPath(roundedRect: rect, cornerWidth: self.frame.width*0.5, cornerHeight: self.frame.height*0.5, transform: nil)
        setPhysics()
    }
    
    func moveTo(_ to: CGPoint, duration: TimeInterval?) {
        if duration == nil {
            let rect = CGRect(x: to.x, y: to.y, width: self.frame.width, height: self.frame.height)
            path = CGPath(roundedRect: rect, cornerWidth: self.frame.width*0.5, cornerHeight: self.frame.height*0.5, transform: nil)
        } else {
            self.run(SKAction.move(to: to, duration: duration!))
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
