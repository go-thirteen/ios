//
//  GameSquare.swift
//  Thirteen
//
//  Created by Wilhelm Thieme on 20/03/2020.
//  Copyright © 2020 Wilhelm Thieme. All rights reserved.
//

import UIKit

class GameSquare: UIView {
    
    private let label = UILabel()
    var text: String? {
        get { return label.text }
        set { label.text = newValue}
    }
    
    
    init(spacing: CGFloat) {
        super.init(frame: .zero)
        
        label.textAlignment = .center
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: UIFont.labelFontSize * 2)
        addSubview(label)
        label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: spacing).isActive = true
        label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -spacing).isActive = true
        label.topAnchor.constraint(equalTo: topAnchor, constant: spacing).isActive = true
        label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -spacing).isActive = true
        
        layer.cornerRadius = 4
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}
