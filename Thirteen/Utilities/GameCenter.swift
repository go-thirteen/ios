//
//  GameCenter.swift
//  Thirteen
//
//  Created by Wilhelm Thieme on 24/03/2020.
//  Copyright © 2020 Wilhelm Thieme. All rights reserved.
//

import Foundation
import GameKit
//import GameplayKit

class GameCenter: NSObject, GKGameCenterControllerDelegate {
    private static let delegate = GameCenter()
    
    private static let leaderbordID = "com.wjthieme.Thirteen"
    
    private static var gameCenterEnabled = false
    private static var gameCenterLeaderboardID: String?
    
    static func addScoreToGameCenter(_ score: Int) {
        guard gameCenterEnabled else { return }
        let scoreObj = GKScore(leaderboardIdentifier: leaderbordID)
        scoreObj.value = Int64(score)
        GKScore.report([scoreObj]) { (error) in
            //TODO: <-
        }
    }

    static func authenticateLocalPlayer() {
        GKLocalPlayer.local.authenticateHandler = { controller, error in
            if let error = error { return } //TODO: <-
            guard GKLocalPlayer.local.isAuthenticated else { return } //TODO: <-
            gameCenterEnabled = true
            loadDefaultLeaderboard()
        }
    }
    
    private static func loadDefaultLeaderboard() {
        GKLocalPlayer.local.loadDefaultLeaderboardIdentifier { id, error in
            if let error = error { return } //TODO: <-
            gameCenterLeaderboardID = id
        }
    }
    
    static func openGameCenterController(on viewController: UIViewController) {
        let controller = GKGameCenterViewController()
        controller.gameCenterDelegate = delegate
        controller.viewState = .leaderboards
        controller.leaderboardIdentifier = leaderbordID
        viewController.present(controller, animated: true, completion: nil)
    }

    
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }
    
}
