//
//  ButtonNode.swift
//  Thirteen
//
//  Created by Wilhelm Thieme on 2/8/18.
//  Copyright © 2018 Wilhelm Thieme. All rights reserved.
//

import SpriteKit

class ButtonNode: SKSpriteNode {
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
        
        isUserInteractionEnabled = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var selector: (() -> Void)?
    
    
    func addTarget(_ action: (() -> Void)?) {
        selector = action
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let select = selector {
            select()
        }
    }
    
}
