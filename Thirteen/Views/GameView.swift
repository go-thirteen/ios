//
//  GameView.swift
//  Thirteen
//
//  Created by Wilhelm Thieme on 20/03/2020.
//  Copyright © 2020 Wilhelm Thieme. All rights reserved.
//

import UIKit

@objc protocol GameViewDataSource: AnyObject {
    @objc optional func gameView(numberOfRowsIn gameView: GameView) -> Int
    @objc optional func gameView(numberOfSectionsIn gameView: GameView) -> Int
    @objc optional func gameView(_ gameView: GameView, valueFor indexPath: IndexPath) -> String
}

@objc protocol GameViewDelegate: AnyObject {
    @objc optional func gameView(_ gameView: GameView, didComit selection: [IndexPath])
    @objc optional func gameView(_ gameView: GameView, shouldCombine indexPath: IndexPath, with group: [IndexPath]) -> Bool
}

class GameView: UIView {
    
    private var arrangedSubviews: [IndexPath: GameSquare] = [:]
    
    private var selectedIndexPaths: [IndexPath] = []
    private var rows: Int = 3
    private var columns: Int = 3
    
    var spacing: CGFloat = 8
    @IBOutlet weak var dataSource: GameViewDataSource?
    @IBOutlet weak var delegate: GameViewDelegate?
    
    
    init() {
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layoutGrid()
        reloadValues()
    }
    
    func layoutGrid() {
        arrangedSubviews.forEach { $0.value.removeFromSuperview() }
        arrangedSubviews = [:]
        rows = dataSource?.gameView?(numberOfRowsIn: self) ?? 3
        columns = dataSource?.gameView?(numberOfSectionsIn: self) ?? 3
        
        for c in 0..<columns {
            for r in 0..<rows {
                let i = IndexPath(row: r, section: c)
                let view = GameSquare(spacing: spacing)
                view.translatesAutoresizingMaskIntoConstraints = false
                view.backgroundColor = UIColor(named: "tint")
                
                addSubview(view)
                arrangedSubviews[i] = view
                
                let l = arrangedSubviews[i--1]?.trailingAnchor ?? leadingAnchor
                view.leadingAnchor.constraint(equalTo: l, constant: spacing).isActive = true
                
                let t = arrangedSubviews[i-|1]?.bottomAnchor ?? topAnchor
                view.topAnchor.constraint(equalTo: t, constant: spacing).isActive = true
                
                if c == columns-1 { view.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -spacing).isActive = true }
                if r == rows-1 { view.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -spacing).isActive = true }
                arrangedSubviews[i--1]?.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
                arrangedSubviews[i-|1]?.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
                
            }
        }
    }
    
    func reloadValues() {
        for c in 0..<columns {
            for r in 0..<rows {
                let i = IndexPath(row: r, section: c)
                arrangedSubviews[i]?.text = dataSource?.gameView?(self, valueFor: i)
                arrangedSubviews[i]?.backgroundColor = arrangedSubviews[i]?.backgroundColor?.withAlphaComponent(selectedIndexPaths.contains(i) ? 0.8 : 1)
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        guard let loc = touches.first?.location(in: self) else { return }
        addPositionIfNeeded(loc)
        reloadValues()
    }
   
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        guard let loc = touches.first?.location(in: self) else { return }
        addPositionIfNeeded(loc)
        reloadValues()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        guard let loc = touches.first?.location(in: self) else { return }
        addPositionIfNeeded(loc)
        delegate?.gameView?(self, didComit: selectedIndexPaths)
        selectedIndexPaths = []
        reloadValues()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        selectedIndexPaths = []
        reloadValues()
    }
    
    
    private func addPositionIfNeeded(_ location: CGPoint) {
        let indexPath = position(of: location)
        if selectedIndexPaths[safe: selectedIndexPaths.count-2] == indexPath { selectedIndexPaths.removeLast(1); return }
        if selectedIndexPaths.contains(indexPath) { return }
        guard delegate?.gameView?(self, shouldCombine: indexPath, with: selectedIndexPaths) ?? true else { return }
        selectedIndexPaths.append(indexPath)
    }
    
    
    private func position(of location: CGPoint) -> IndexPath {
        let r = Int(location.y / (bounds.height / CGFloat(rows)))
        let y = min(max(r, 0), rows-1)
        let c = Int(location.x / (bounds.width / CGFloat(columns)))
        let x = min(max(c, 0), columns-1)
        return IndexPath(row: y, section: x)
    }
    
}
