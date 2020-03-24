//
//  GameSquare.swift
//  Thirteen
//
//  Created by Wilhelm Thieme on 20/03/2020.
//  Copyright © 2020 Wilhelm Thieme. All rights reserved.
//

import UIKit

class GameSquare: UIView {
    
    var value = 0 { didSet { label.text = value == 0 ? "" : "\(value)" }}
    
    private let label = UILabel()
    
    init() {
        super.init(frame: .zero)
        
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
        label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 4).activated()
        label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -4).activated()
        label.topAnchor.constraint(equalTo: topAnchor, constant: 4).activated()
        label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4).activated()
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
