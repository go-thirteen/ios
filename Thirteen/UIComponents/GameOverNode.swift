//
//  GameOverNode.swift
//  13!
//
//  Created by Wilhelm Thieme on 10/22/17.
//  Copyright © 2017 Wilhelm Thieme. All rights reserved.
//

import SpriteKit

class GameOverNode : SKShapeNode {
    
    private var label: SKLabelNode

    required init(coder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    init(rect: CGRect, cornerRadius : CGFloat) {
        label = SKLabelNode(fontNamed: "Helvetica")
        
        super.init()
        
        path = CGPath(roundedRect: rect, cornerWidth: cornerRadius, cornerHeight: cornerRadius, transform: nil)
        fillColor = SKColor.black.withAlphaComponent(0.3)
        
        label.verticalAlignmentMode = .center;
        label.horizontalAlignmentMode = .center;
        label.text = "Game Over!"
        label.fontColor = UIColor.darkGray
        label.fontSize = 50 //dependant on size
        label.position = CGPoint(x: rect.midX, y: rect.midY)
        addChild(label)
        
        
    }
    
    
}
