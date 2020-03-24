//
//  ScoreView.swift
//  Thirteen
//
//  Created by Wilhelm Thieme on 24/03/2020.
//  Copyright © 2020 Wilhelm Thieme. All rights reserved.
//

import UIKit

class ScoreView: UIView {
    
    private let scoreTitleLabel = UILabel()
    private let scoreLabel = UILabel()
    private let highscoreTitleLabel = UILabel()
    private let highscoreLabel = UILabel()
    
    var score: Int = 0 { didSet { scoreLabel.text = "\(score)" } }
    var highscore: Int = 0 { didSet { highscoreLabel.text = "\(highscore)" } }
    
    init() {
        super.init(frame: .zero)
        
        
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
