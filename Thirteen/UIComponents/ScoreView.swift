//
//  ScoreView.swift
//  13!
//
//  Created by Wilhelm Thieme on 10/16/17.
//  Copyright © 2017 Wilhelm Thieme. All rights reserved.
//

import SpriteKit

class ScoreView : SKShapeNode {
    
    var score = 0 {
        didSet {
            
            scoreLabel.text = "\(score)"
            
            if score > highScore {
                highScore = score
                UserDefaults.standard.set(highScore, forKey: Keys.highScore)
            }
        }
    }
    
    private var highScore : Int {
        didSet {
            highScoreLabel.text = "\(score)"
        }
    }
    
    private var scoreLabel: SKLabelNode
    private var highScoreLabel: SKLabelNode
    
    private var titleLabel: SKLabelNode
    private var highScoreTitleLabel : SKLabelNode
    
    required init(coder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    init(rect: CGRect, cornerRadius: CGFloat, color : SKColor) {
        titleLabel = SKLabelNode(fontNamed: "Helvetica")
        highScoreTitleLabel = SKLabelNode(fontNamed: "Helvetica")
        scoreLabel = SKLabelNode(fontNamed: "Helvetica")
        highScoreLabel = SKLabelNode(fontNamed: "Helvetica")
        
        highScore = UserDefaults.standard.integer(forKey: Keys.highScore)
        
        super.init()
        
        path = CGPath(roundedRect: rect, cornerWidth: cornerRadius, cornerHeight: cornerRadius, transform: nil)
        fillColor = color
        isUserInteractionEnabled = true
        
        titleLabel.verticalAlignmentMode = .center;
        titleLabel.horizontalAlignmentMode = .center;
        titleLabel.text = "Score:"
        titleLabel.fontColor = UIColor.darkGray
        titleLabel.fontSize = 20 //dependant on size
        titleLabel.position = CGPoint(x: rect.midX, y: rect.maxY-20)
        addChild(titleLabel)
        
        highScoreTitleLabel.verticalAlignmentMode = .center;
        highScoreTitleLabel.horizontalAlignmentMode = .center;
        highScoreTitleLabel.text = "Highscore:"
        highScoreTitleLabel.fontColor = UIColor.darkGray
        highScoreTitleLabel.fontSize = 20
        highScoreTitleLabel.position = CGPoint(x: rect.midX, y: rect.midY-10)
        addChild(highScoreTitleLabel)
        
        scoreLabel.verticalAlignmentMode = .center;
        scoreLabel.horizontalAlignmentMode = .center;
        scoreLabel.text = "\(score)"
        scoreLabel.fontColor = UIColor.lightGray
        scoreLabel.position = CGPoint(x: rect.midX, y: rect.maxY-50)
        addChild(scoreLabel)
        
        highScoreLabel.verticalAlignmentMode = .center;
        highScoreLabel.horizontalAlignmentMode = .center;
        highScoreLabel.text = "\(highScore)"
        highScoreLabel.fontColor = UIColor.lightGray
        highScoreLabel.position = CGPoint(x: rect.midX, y: rect.midY-35)
        addChild(highScoreLabel)
    }
    
}
