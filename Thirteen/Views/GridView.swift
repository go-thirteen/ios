//
//  GridView.swift
//  Thirteen
//
//  Created by Wilhelm Thieme on 20/03/2020.
//  Copyright © 2020 Wilhelm Thieme. All rights reserved.
//

import UIKit

class GridView<Subview: UIView>: UIView {

    var arrangedSubviews: [Subview] = []
    
    init(_ dim: Int) {
        super.init(frame: .zero)
        
        let num = Int(pow(Float(dim), 2))
        (0..<num).forEach {
            let view = Subview()
            view.tag = $0
            view.translatesAutoresizingMaskIntoConstraints = false
            
            addSubview(view)
            arrangedSubviews.append(view)
            
            let c = $0 % dim
            let r = $0 / dim
            
            let l = c == 0 ? leadingAnchor : arrangedSubviews[$0-1].trailingAnchor
            view.leadingAnchor.constraint(equalTo: l, constant: 4).activated()
            
            let t = r == 0 ? topAnchor : arrangedSubviews[$0-dim].bottomAnchor
            view.topAnchor.constraint(equalTo: t, constant: 4).activated()
            
            if c == dim-1 { view.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -4).activated() }
            if r == dim-1 { view.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4).activated() }
            if c != 0 { view.widthAnchor.constraint(equalTo: arrangedSubviews[$0-1].widthAnchor).activated() }
            if r != 0 { view.heightAnchor.constraint(equalTo: arrangedSubviews[$0-dim].heightAnchor).activated() }
            
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
