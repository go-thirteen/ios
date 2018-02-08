//
//  GameScene.swift
//  13!
//
//  Created by Wilhelm Thieme on 10/15/17.
//  Copyright © 2017 Wilhelm Thieme. All rights reserved.
//

import SpriteKit
import GameplayKit
import CoreMotion

class GameScene: SKScene {
    
    private var gameNode : GameView
    private var buttonNode : ButtonView
    private var scoreNode : ScoreView
    private var noEscapeShape : NoEscapeNode
    private var motionManager = CMMotionManager()
    
    required init(coder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    init(rect: CGRect) {
        let color = SKColor(displayP3Red: 253/255, green: 245/255, blue: 230/255, alpha: 1)
        let padding : CGFloat = 20
        let cornerRad :CGFloat = 20
        
        let statusH : CGFloat = 150
        
        
        let buttonW = statusH
        let buttonH = statusH
        let buttonX = padding
        let buttonY = rect.height - padding - buttonH
        let buttonRect = CGRect(x: buttonX, y: buttonY, width: buttonW, height: buttonH)
        self.buttonNode = ButtonView(rect: buttonRect, cornerRadius: cornerRad, color: color, text: "Start")
        
        let scoreW = rect.width - buttonW - padding * 3
        let scoreH = statusH
        let scoreX = buttonX + buttonW + padding
        let scoreY = buttonY
        let scoreRect = CGRect(x: scoreX, y: scoreY, width: scoreW, height: scoreH)
        self.scoreNode = ScoreView(rect: scoreRect, cornerRadius: cornerRad, color: color)
        
        
        let backW = rect.width - padding * 2
        let backH = rect.height - statusH - padding * 3
        let backX = padding
        let backY = padding
        let backRect = CGRect(x: backX, y: backY, width: backW, height: backH)
        self.gameNode = GameView(rect: backRect, cornerRadius: cornerRad, color: color)
        
        let escapeW = rect.width*2
        let escapeH = rect.height*2
        let escapeX = rect.midX - rect.width*0.5
        let escapeY = rect.midY - rect.height*0.5
        let escapeRect = CGRect(x: escapeX, y: escapeY, width: escapeW, height: escapeH)
        self.noEscapeShape = NoEscapeNode(rect: escapeRect, cutout: backRect)
        
        super.init(size: rect.size)
        
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        
        motionManager.accelerometerUpdateInterval = 0.3
        motionManager.startAccelerometerUpdates(to: OperationQueue.current!, withHandler: { (data, error) in
            if let raw = data {
                let gravX = raw.acceleration.x * 5
                let gravY = raw.acceleration.y * 5
                self.physicsWorld.gravity = CGVector(dx: gravX, dy: gravY)
            }
            })
        
        
        
        self.buttonNode.setButtonAction(target: self, triggerEvent: .TouchUpInside, action: #selector(self.startButton))
        self.addChild(noEscapeShape)
        self.addChild(buttonNode)
        self.addChild(scoreNode)
        self.addChild(gameNode)
    }
    
    override func didMove(to view: SKView) {
        
    }
    
    @objc func startButton() {
        gameNode.restart()
        buttonNode.title = "Restart"
    }
    
    func updateScore(_ score : Int) {
        scoreNode.score = score
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
