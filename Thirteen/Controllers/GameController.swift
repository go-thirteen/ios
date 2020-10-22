//
//  ViewController.swift
//  Thirteen
//
//  Created by Wilhelm Thieme on 20/03/2020.
//  Copyright © 2020 Wilhelm Thieme. All rights reserved.
//

import UIKit

fileprivate let dim = 3

class GameController: UIViewController {
    
    @IBOutlet private weak var gameView: GameView!
    @IBOutlet private weak var scoreLabel: UILabel!
    @IBOutlet private weak var highscoreLabel: UILabel!
    @IBOutlet private weak var modeButton: UIButton!
    @IBOutlet private weak var gameoverView: UIView!
    
    private var board: Board = GameType.current.boardType.load()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: "GameView", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        modeButton.setTitle(GameType.current.localizedTitle, for: .normal)
        updateScoreLabels()
        
        if board.isGameOver {
            gameoverView.isHidden = false
            gameoverView.alpha = 1
        }
    }
    
    @IBAction private func restart() {
        GameCenterService.addScoreToGameCenter(board.score, type: GameType.current)
        modeButton.setTitle(GameType.current.localizedTitle, for: .normal)
        board = GameType.current.boardType.load(fresh: true)
        hideGameoverView()
        gameView.layoutGrid()
        gameView.reloadValues()
        updateScoreLabels()
    }
    
    @IBAction private func openModeSelector(sender: UIButton) {
        let alert = AlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        GameType.allCases.forEach { t in
            alert.addAction(UIAlertAction(title: t.localizedTitle, style: .default, handler: { [self] _ in
            if GameType.current == t { return }
            GameType.current = t
            restart()
            }))
        }
        alert.addAction(UIAlertAction(title: localizedString("cancel"), style: .cancel, handler: nil))
        alert.popoverPresentationController?.sourceView = sender
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction private func openGameCenter() {
        GameCenterService.openGameCenterController(on: self, type: GameType.current)
    }
    
    @IBAction private func openAbout(sender: UIButton) {
        let controller = AboutController()
        present(controller, animated: true, completion: nil)
    }
    
    private func gameover() {
        GameCenterService.addScoreToGameCenter(board.score, type: GameType.current)
        showGameoverView()
    }
    
    private func updateScoreLabels() {
        scoreLabel.text = localizedNumber(board.score)
        highscoreLabel.text = localizedNumber(max(board.score, GameType.current.highscore))
        if board.score > GameType.current.highscore {
            GameType.current.highscore = board.score
        }
    }
    
    
    private func showGameoverView() {
        gameoverView.isHidden = false
        UIView.animate(withDuration: 0.5) { [self] in
            gameoverView.alpha = 1
        }
    }
    
    private func hideGameoverView() {
        UIView.animate(withDuration: 0.5) { [self] in
            gameoverView.alpha = 0
        } completion: { [self] _ in
            gameoverView.isHidden = true
        }

    }
    

}

extension GameController: GameViewDelegate, GameViewDataSource {
    
    func gameView(numberOfRowsIn gameView: GameView) -> Int {
        return type(of: board).rows
    }
    
    func gameView(numberOfSectionsIn gameView: GameView) -> Int {
        return type(of: board).columns
    }
    
    func gameView(_ gameView: GameView, shouldCombine indexPath: IndexPath, with group: [IndexPath]) -> Bool {
        return board.canAdd(indexPath: indexPath, to: group)
    }
    
    func gameView(_ gameView: GameView, didComit selection: [IndexPath]) {
        board.sumPositions(selection)

        updateScoreLabels()
        gameView.reloadValues()
        
        if let last = selection.last, board[last]?.value == 13 {
            board.popIndexPath(last)
            gameView.pop(last)
        }
        
        if board.isGameOver { gameover() }
    }
    
    func gameView(_ gameView: GameView, valueFor indexPath: IndexPath) -> String {
        guard let value = board[indexPath]?.value else { return "" }
        if value == 13 { return "13!" }
        return "\(value)"
    }
}
