//
//  NoEscapeNode.swift
//  13!
//
//  Created by Wilhelm Thieme on 10/21/17.
//  Copyright © 2017 Wilhelm Thieme. All rights reserved.
//

import SpriteKit

class NoEscapeNode : SKShapeNode {
    
    
    let up = SKShapeNode()
    let down = SKShapeNode()
    let left = SKShapeNode()
    let right = SKShapeNode()
    
    required init(coder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    init(rect: CGRect, cutout: CGRect) {
        super.init()
        
        
        up.path = CGPath(rect: CGRect(x: rect.minX, y: cutout.maxY, width: rect.width, height: rect.height-cutout.maxY), transform: nil)
        up.physicsBody = SKPhysicsBody(polygonFrom: up.path!)
        up.physicsBody!.affectedByGravity = false
        up.physicsBody!.isDynamic = false
        up.strokeColor = .clear
        self.addChild(up)
        
        down.path = CGPath(rect: CGRect(x: rect.minX, y: rect.minY, width: rect.width, height: cutout.minX-rect.minX), transform: nil)
        down.physicsBody = SKPhysicsBody(polygonFrom: down.path!)
        down.physicsBody!.affectedByGravity = false
        down.physicsBody!.isDynamic = false
        down.strokeColor = .clear
        self.addChild(down)
        
        right.path = CGPath(rect: CGRect(x: cutout.maxX, y: rect.minY, width: rect.width-cutout.maxX, height: rect.height), transform: nil)
        right.physicsBody = SKPhysicsBody(polygonFrom: right.path!)
        right.physicsBody!.affectedByGravity = false
        right.physicsBody!.isDynamic = false
        right.strokeColor = .clear
        self.addChild(right)
        
        left.path = CGPath(rect: CGRect(x: rect.minX, y: rect.minY, width: cutout.minX-rect.minX, height: rect.height), transform: nil)
        left.physicsBody = SKPhysicsBody(polygonFrom: left.path!)
        left.physicsBody!.affectedByGravity = false
        left.physicsBody!.isDynamic = false
        left.strokeColor = .clear
        self.addChild(left)
        

    }

}
