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
    
    let contactNothing: UInt32 = 0x0
    let contactBall: UInt32 = 0x1 << 0
    
    var isPickedUp: Bool = false {
        didSet {
            isSelected = isPickedUp
            
            if isPickedUp != oldValue {
                if isPickedUp {
                    self.physicsBody?.categoryBitMask = contactNothing
                    self.physicsBody?.collisionBitMask = contactNothing
                    self.physicsBody?.affectedByGravity = false
                } else {
                   self.physicsBody?.categoryBitMask = contactBall
                    self.physicsBody?.collisionBitMask = contactBall
                    self.physicsBody?.affectedByGravity = true
                }
            }
            
        }
    }
    
    var size: CGFloat
    
    init(size: CGFloat) {
        
        self.size = size
        
        let rand = arc4random_uniform(UInt32(Colors.shadesOfRed.count))
        let color = Colors.shadesOfRed[Int(rand)]
        
        self.defaultColor = color
        self.selectedColor = color.withAlphaComponent(0.5)
        self.textColor = SKColor.black
        self.selectedTextColor = SKColor.white
        
        super.init()
        
        buildFrame(size)
        
        fillColor = self.defaultColor
        
        label.verticalAlignmentMode = .center
        label.horizontalAlignmentMode = .center
        label.position = self.position
        label.fontColor = SKColor.black
        label.text = title
        if UIDevice.current.userInterfaceIdiom == .pad {
            label.fontSize *= 2
        }
        addChild(label)
        
    }
    
    private func setPhysics(diameter: CGFloat) {
        let radius = diameter/2
        let physics = SKPhysicsBody(circleOfRadius: radius)
        physics.categoryBitMask = contactBall
        physics.affectedByGravity = true
        physics.restitution = 0
        physics.linearDamping = 0.2
        physics.contactTestBitMask = contactBall
        physicsBody = physics
    }
    
    func grow(to: CGFloat) {
        buildFrame(to)
        self.size = to
    }
    
    private func inverse(color : SKColor) -> SKColor {
        var blue : CGFloat = 0
        var green : CGFloat = 0
        var alpha : CGFloat = 0
        var red : CGFloat = 0
        color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return SKColor(red: 1-red, green: 1-green, blue: 1-blue, alpha: 1)
    }
    
    func buildFrame(_ size: CGFloat) {
        setPhysics(diameter: size)
        
        let origin = CGPoint(x: -size*0.5, y: -size*0.5)
        let rect = CGRect(origin: origin, size: CGSize(width: size, height: size))
        self.path = CGPath(ellipseIn: rect, transform: nil)
    }
    
}
