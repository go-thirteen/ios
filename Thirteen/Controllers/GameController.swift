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
    
    private var board: Board = GameType.current.boardType.init()
    
    
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
    }
    
    @IBAction private func restart() {
        GameCenterService.addScoreToGameCenter(board.score, id: GameType.current.rawValue)
        modeButton.setTitle(GameType.current.localizedTitle, for: .normal)
        board = GameType.current.boardType.init(fresh: true)
        gameView.layoutGrid()
        gameView.reloadValues()
        updateScoreLabels()
    }
    
    @IBAction private func openModeSelector(sender: UIButton) {
        let alert = AlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        GameType.allCases.forEach { t in
            alert.addAction(UIAlertAction(title: t.localizedTitle, style: .default, handler: { _ in
            if GameType.current == t { return }
            GameType.current = t
            self.restart()
            }))
        }
        alert.addAction(UIAlertAction(title: localizedString("cancel"), style: .cancel, handler: nil))
        alert.popoverPresentationController?.sourceView = sender
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction private func openGameCenter() {
        GameCenterService.openGameCenterController(on: self, id: GameType.current.rawValue)
    }
    
    @IBAction private func openAbout(sender: UIButton) {
        let controller = AboutController()
        present(controller, animated: true, completion: nil)
    }
    
    private func gameover() {
        GameCenterService.addScoreToGameCenter(board.score, id: GameType.current.rawValue)
        
        //TODO: SHow gameover
    }
    
    private func updateScoreLabels() {
        scoreLabel.text = localizedNumber(board.score)
        highscoreLabel.text = localizedNumber(max(board.score, GameType.current.highscore))
        if board.score > GameType.current.highscore {
            GameType.current.highscore = board.score
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
