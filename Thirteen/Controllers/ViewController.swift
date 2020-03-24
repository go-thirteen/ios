//
//  ViewController.swift
//  Thirteen
//
//  Created by Wilhelm Thieme on 20/03/2020.
//  Copyright © 2020 Wilhelm Thieme. All rights reserved.
//

import UIKit

fileprivate let dim = 3

class ViewController: UIViewController {
    
    private let gameView = GameView(dim)
    private let menuButton = UIButton()
    private let scoreView = ScoreView()
    
    private var board = Board(dim*dim)
    private var selectedPositions: [Int] = []
    private var isGameover = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.systemBackground
        
        menuButton.setImage(UIImage(systemName: "gear", withConfiguration: UIImage.SymbolConfiguration(pointSize: 24)), for: .normal)
        menuButton.tintColor = UIColor(named: "tint")
        menuButton.addTarget(self, action: #selector(restart), for: .touchUpInside)
        menuButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(menuButton)
        menuButton.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 8).activated()
        menuButton.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -8).activated()
        
        let gPad: CGFloat = UIDevice.current.userInterfaceIdiom == .pad ? 58 : 8
        gameView.translatesAutoresizingMaskIntoConstraints = false
        gameView.didHighlightPositions = { [weak self] x in self?.didHighlightPositions(x) }
        gameView.didSelectPositions = { [weak self] x in self?.didSelectPositions(x) }
        view.addSubview(gameView)
        gameView.centerYAnchor.constraint(equalTo: view.centerYAnchor).activated()
        gameView.centerXAnchor.constraint(equalTo: view.centerXAnchor).activated()
        gameView.widthAnchor.constraint(equalTo: gameView.heightAnchor).activated()
        gameView.leadingAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.leadingAnchor, constant: gPad).activated()
        gameView.trailingAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -gPad).activated()
        gameView.topAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.topAnchor, constant: gPad).activated()
        gameView.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -gPad).activated()
        gameView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: gPad).activated(.defaultHigh)
        gameView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -gPad).activated(.defaultHigh)
        gameView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: gPad).activated(.defaultHigh)
        gameView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -gPad).activated(.defaultHigh)
        
        
        scoreView.score = board.score
        scoreView.highscore = Defaults.highscore.int()
        //TODO: <-
        
        
        drawLoop()
        board.save()
    }
    
    @objc private func restart() {
        if !isGameover { GameCenter.addScoreToGameCenter(board.score) }
        board = Board(dim*dim, fresh: true)
        isGameover = false
        drawLoop()
    }
    
    private func gameover() {
        GameCenter.addScoreToGameCenter(board.score)
        isGameover = true
        selectedPositions = []
    }
    
    private func drawLoop() {
        let gameoverSquares = board.gameover
        
        if !gameoverSquares.isEmpty {
            isGameover = true
            selectedPositions = []
        }
        
        
        gameView.arrangedSubviews.forEach {
            $0.backgroundColor = .blue
        }

        selectedPositions.forEach {
            gameView.arrangedSubviews[$0].backgroundColor = .brown
        }
        
        for n in 0..<board.count {
            gameView.arrangedSubviews[n].value = board[n].value
        }
        
        
        
        if !gameoverSquares.isEmpty {
            gameoverSquares.forEach {
                gameView.arrangedSubviews[$0].backgroundColor = .red
            }
        }
        
    }
    
    private func shouldSelectPositions(_ positions: [Int]) -> [Int] {
        guard let first = positions.first else { return [] }
        if board[first].isEmpty { return [] }
        var pos = positions
        while let last = pos.last, board[last].isEmpty {
            pos.removeLast()
        }
        return pos
    }
    
    private func didHighlightPositions(_ positions: [Int]) {
        if isGameover { return }
        selectedPositions = shouldSelectPositions(positions)
        drawLoop()
    }
    
    private func didSelectPositions(_ positions: [Int]) {
        if isGameover { return }
        let selected = shouldSelectPositions(positions)
        board.sumPositions(selected)
        scoreView.score = board.score
        print(board.score)
        if board.score > Defaults.highscore.int() {
            Defaults.highscore.set(board.score)
            scoreView.highscore = board.score
        }
        drawLoop()
        board.save()
    }
    

    
}
