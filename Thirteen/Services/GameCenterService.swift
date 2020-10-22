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

class GameCenterService: NSObject, GKGameCenterControllerDelegate {
    private static let delegate = GameCenterService()
    
    private static var gameCenterEnabled = false
    
    static func addScoreToGameCenter(_ score: Int, type: GameType) {
        guard gameCenterEnabled else { return }
        let scoreObj = GKScore(leaderboardIdentifier: type.scoreboardId)
        scoreObj.value = Int64(score)
        GKScore.report([scoreObj]) { (error) in
            if let error = error { AnalyticsService.log(error) }
        }
    }

    static func authenticateLocalPlayer() {
        GKLocalPlayer.local.authenticateHandler = { controller, error in
            if let error = error { AnalyticsService.log(error); return }
            guard GKLocalPlayer.local.isAuthenticated else { return }
            gameCenterEnabled = true
        }
    }
    
    static func openGameCenterController(on viewController: UIViewController, type: GameType) {
        let controller = GKGameCenterViewController()
        controller.gameCenterDelegate = delegate
        controller.viewState = .leaderboards
        controller.leaderboardIdentifier = type.scoreboardId
        viewController.present(controller, animated: true, completion: nil)
    }

    
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }
    
}
