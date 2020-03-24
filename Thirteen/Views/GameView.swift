//
//  GameView.swift
//  Thirteen
//
//  Created by Wilhelm Thieme on 20/03/2020.
//  Copyright © 2020 Wilhelm Thieme. All rights reserved.
//

import UIKit


//fileprivate let num = Int(pow(Float(dim), 2))

class GameView: GridView<GameSquare> {
    
    var didHighlightPositions: (([Int]) -> Void)?
    var didSelectPositions: (([Int]) -> Void)?
    
    private let dimension: Int
    
    override init(_ dim: Int) {
        dimension = dim
        super.init(dim)
        backgroundColor = .secondarySystemBackground
        
        arrangedSubviews.forEach {
            $0.backgroundColor = .blue
            $0.isUserInteractionEnabled = false
        }
        
    }
    
    
    private var startPosition: CGPoint?
    private var endPosition: CGPoint?
    private var selectedPositions: [Int] {
        guard let start = startPosition else { return [] }
        guard var end = endPosition else { return [] }
        let d = CGPoint(x: end.x - start.x, y:  end.y - start.y)
        let horizontal = abs(d.x) > abs(d.y)
        end = horizontal ? CGPoint(x: end.x, y: start.y) : CGPoint(x: start.x, y: end.y)
        
        let startIndex = position(of: start)
        let endIindex = position(of: end)
        let reversed = startIndex > endIindex

        let rhs = horizontal ? 1 : dimension
        let op = reversed ? -rhs : rhs
        var arr = [startIndex]
        while arr.last! != endIindex {
            arr.append(arr.last! + op)
        }
        
        return arr
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        guard let loc = touches.first?.location(in: self) else { return }
        startPosition = loc
        endPosition = loc
        didHighlightPositions?(selectedPositions)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        guard let loc = touches.first?.location(in: self) else { return }
        endPosition = loc
        didHighlightPositions?(selectedPositions)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        guard let loc = touches.first?.location(in: self) else { return }
        endPosition = loc
        didSelectPositions?(selectedPositions)
        startPosition = nil
        didHighlightPositions?(selectedPositions)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        startPosition = nil
        didHighlightPositions?(selectedPositions)
    }
    
    
    private func position(of location: CGPoint) -> Int {
        let r = Int(location.x / (bounds.width / CGFloat(dimension)))
        let x = min(max(r, 0), dimension-1)
        let c = Int(location.y / (bounds.height / CGFloat(dimension)))
        let y = min(max(c, 0), dimension-1)
        return x + y * dimension
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
