//
//  GameView.swift
//  13!
//
//  Created by Wilhelm Thieme on 10/16/17.
//  Copyright © 2017 Wilhelm Thieme. All rights reserved.
//

import SpriteKit

class GameView : SKShapeNode {
    
    private var nodes : [BallNode] = []
    private var gameOverNode : GameOverNode
    private var score = 0 {
        didSet {
            if let p = parent as? GameScene {
                p.updateScore(score)
            }
        }
    }
    
    private var running = true {
        didSet {
            isUserInteractionEnabled = running
        }
    }
    
    required init(coder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    init(rect: CGRect, cornerRadius: CGFloat, color : SKColor) {
        
        gameOverNode = GameOverNode(rect: rect, cornerRadius: cornerRadius)
        
        super.init()
        
        path = CGPath(roundedRect: rect, cornerWidth: cornerRadius, cornerHeight: cornerRadius, transform: nil)
        let physics = SKPhysicsBody(edgeLoopFrom: path!)
        physics.affectedByGravity = false
        physics.isDynamic = false
        physics.friction = 0
        physicsBody = physics
        fillColor = color
        isUserInteractionEnabled = true
    }
    
    func addNode(_ times : Int) {
        for _ in 0...times-1 {
        let size = (self.frame.width + self.frame.height) * getFactor(1)
        let pos = CGPoint(x: self.frame.width*0.5, y: self.frame.height*0.5)
        self.nodes.append(BallNode(size: size, position: pos))
        
        let op = Int(arc4random_uniform(99))
        
        
        if op < 10 {
            nodes.last!.oper = .multiply
            let value = Int(arc4random_uniform(2))
            if value == 0 {
                nodes.last!.value = -1
            } else if value == 1 {
                nodes.last!.value = 2
            } else {
                nodes.last!.value = 3
            }
        } else if op >= 10 {
            nodes.last!.oper = .plus
            
            let value = generateNumber()
            
            nodes.last!.value = value
        }
        
        self.addChild(self.nodes.last!)
            
            score += abs(self.nodes.last!.value)
        }
    }
    
    func generateNumber() -> Int {
        var random = 0
        for _ in 0...9 {
            random += Int(arc4random_uniform(11)) - 5
        }
        random += 6
        if random == 0 || random == 13 {
            random = generateNumber()
        }
        return random
    }
    
    func clearBoard() {
        for node in nodes {
            node.removeFromParent()
        }
        nodes = []
    }
    
    func getPoints(from: CGRect) -> (CGPoint, CGPoint, CGPoint, CGPoint) {
        let minX = from.minX
        let minY = from.minY
        let maxX = from.maxX
        let maxY = from.maxY
        
        let one = CGPoint(x: minX, y: minY)
        let two = CGPoint(x: minX, y: maxY)
        let three = CGPoint(x: maxX, y: minY)
        let four = CGPoint(x: maxX, y: maxY)
        
        return (one, two, three, four)
    }
    
    var movableNode : BallNode?
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            for node in nodes {
                if node.contains(location) {
                    movableNode = node
                    if let movable = movableNode {
                        movable.physicsBody = nil
                    }
                }
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            let locationInParent = CGPoint(x: location.x-self.frame.minX, y: location.y-self.frame.minY)
        
            if let movable = movableNode {
                movable.zRotation = 0
                let moveLocation = CGPoint(x: locationInParent.x-self.frame.width*0.5-movable.frame.width*0.5, y: locationInParent.y-self.frame.height*0.5-movable.frame.height*0.5)
                let rectInParent = CGRect(x: locationInParent.x-movable.frame.width*0.5, y: locationInParent.y-movable.frame.height*0.5, width: movable.frame.width, height: movable.frame.height)
                let points = getPoints(from: rectInParent)
                if self.contains(points.0) && self.contains(points.1) && self.contains(points.2) && self.contains(points.3) {
                    movable.position = moveLocation
                }
                
                for node in nodes {
                    node.isSelected = node.contains(location)
                }
 
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            let locationInParent = CGPoint(x: location.x-self.frame.minX, y: location.y-self.frame.minY)
            if let movable = movableNode {
            
                var toRemove = false
                var removeNode : BallNode?
                var newValue = 0
                var newOper = BallNode.operators.plus
                var newSize : CGFloat = 0
                var newAdded : CGFloat = 0
                for node in nodes {
                    if node.contains(location) && !node.isEqual(to: movable) {
                        let value1 = movable.value
                        let op1 = movable.oper
                        let value2 = node.value
                        let op2 = node.oper
                        
                        if op1 == .multiply || op2 == .multiply {
                            newValue = value1 * value2
                        } else {
                            newValue = value1 + value2
                        }
                        
                        if op1 == .multiply && op2 == .multiply {
                            newOper = .multiply
                        }
                        
                        newAdded = node.timesAdded + movable.timesAdded
                        let factor = getFactor(newAdded)
                        newSize = (self.frame.width + self.frame.height) * factor
                        
                        toRemove = true
                        removeNode = node
                    }
                }
                
                if toRemove {
                    movable.removeFromParent()
                    let ID = nodes.index(of: movable)
                    if let at = ID {
                        nodes.remove(at: at)
                    }
                    movableNode = nil
                    
                    if let node = removeNode {
                        node.removeFromParent()
                        let ID2 = nodes.index(of: node)
                        if let at = ID2 {
                            nodes.remove(at: at)
                        }
                    }
                    
                    let newNode = BallNode(size: newSize, position: locationInParent)
                    newNode.oper = newOper
                    newNode.value = newValue
                    newNode.timesAdded = newAdded
                    nodes.append(newNode)
                    self.addChild(newNode)
                    
                    if newNode.value == 13 && newNode.oper == .plus {
                        pop(newNode)
                        addNode(2)
                    } else {
                        addNode(1)
                    }
                    
                    if !doesFit((self.frame.width + self.frame.height) * getFactor(1)) {
                        gameOver()
                    }
                    
                } else {
                    movable.isSelected = false
                    movable.setPhysics()
                    movableNode = nil
                }
            }
        }
    }
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let movable = movableNode {
            movable.setPhysics()
            movableNode = nil
        }
    }
    
    func nodeAtLocation(_ at: CGPoint, _ thisNode: BallNode) -> Bool {
        for node in nodes {
            if node.contains(at) && !node.isEqual(to: thisNode) {
                return true
            }
        }
        return false
    }
    
    func pop(_ node: BallNode) {
        let num = Int(arc4random_uniform(5))
        let playSound = SKAction.playSoundFileNamed("Pop\(num).wav", waitForCompletion: false)
        
        if let p = scene as? GameScene,!p.mute {
            node.run(SKAction.sequence([SKAction.wait(forDuration: 0.3), playSound, SKAction.removeFromParent()]))
        } else {
            node.run(SKAction.sequence([SKAction.wait(forDuration: 0.3), SKAction.removeFromParent()]))
        }
        
        
        let ID = nodes.index(of: node)
        if let at = ID {
            nodes.remove(at: at)
        }
        score += 13
        
    }
    
    func doesFit(_ width : CGFloat) -> Bool {

        let rectArea = frame.width * frame.height
        var circleArea : CGFloat = 0
        for node in nodes {
            circleArea += CGFloat.pi * pow(node.frame.width*0.5, 2)
            if node.frame.width > self.frame.width || node.frame.width > self.frame.height {
                return false
            }
        }
        
        let addCircle = CGFloat.pi * pow(width*0.5, 2)
        
        if circleArea + addCircle < rectArea {
            return true
        }
        return false
    }
    
    func getFactor(_ size : CGFloat) -> CGFloat {
        if score < 1000 {
            return (size * 0.02 + 0.08) * (CGFloat(score)/5000 + 1)
        }
        return (size * 0.02 + 0.08) * 1.2
    }
    
    func gameOver() {
        if let vc = self.scene?.view?.window?.rootViewController as? GameViewController {
            self.addChild(gameOverNode)
            running = false
            vc.updateGC(score)
        }

    }
    
    func restart() {
        clearBoard()
        score = 0
        addNode(10)
        gameOverNode.removeFromParent()
        running = true
    }
    
    var timer: Timer?
    
    func startBlinking() {
        let color1 = SKColor(red: 253/255, green: 245/255, blue: 230/255, alpha: 1)
        let color2 = SKColor(red: 203/255, green: 195/255, blue: 180/255, alpha: 1)
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (timer) in
            self.run(SKAction.sequence([SKAction.customAction(withDuration: 0.2, actionBlock: { (node, _) in
                let nod = node as? SKShapeNode
                nod?.fillColor = color2
            }),SKAction.customAction(withDuration: 0.2, actionBlock: { (node, _) in
                let nod = node as? SKShapeNode
                nod?.fillColor = color1
            })]))
        })
    }
    
    func stopBlinking() {
        timer?.invalidate()
    }
}
