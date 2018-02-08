//
//  GameViewController.swift
//  13!
//
//  Created by Wilhelm Thieme on 10/15/17.
//  Copyright © 2017 Wilhelm Thieme. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import GameKit

class GameViewController: UIViewController, GKGameCenterControllerDelegate {
    
    var gcEnabled = Bool()
    var gcDefaultLeaderBoard = String()
    
    let LEADERBOARD_ID = "com.wjthieme.Thirteen"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        authenticateLocalPlayer()
        
        if let view = self.view as! SKView? {
            let scene = GameScene(rect: self.view.frame)
            scene.scaleMode = .aspectFit
            view.presentScene(scene)
            
            view.ignoresSiblingOrder = true
        }
    }
    
    func updateGC(_ score: Int) {
        let scoreObj = GKScore(leaderboardIdentifier: LEADERBOARD_ID)
        scoreObj.value = Int64(score)
        GKScore.report([scoreObj]) { (error) in
            if error != nil {
                print(error!.localizedDescription)
            }
        }
    }
    
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }
    
    func authenticateLocalPlayer() {
        let localPlayer: GKLocalPlayer = GKLocalPlayer.localPlayer()
        
        localPlayer.authenticateHandler = {(ViewController, error) -> Void in
            if((ViewController) != nil) {
                self.present(ViewController!, animated: true, completion: nil)
            } else if (localPlayer.isAuthenticated) {
                self.gcEnabled = true
                localPlayer.loadDefaultLeaderboardIdentifier(completionHandler: { (leaderboardIdentifer, error) in
                    if error != nil {
                        print(error!.localizedDescription)
                    } else {
                        self.gcDefaultLeaderBoard = leaderboardIdentifer!
                    }
                })
                
            } else {
                self.gcEnabled = false
                print("Local player could not be authenticated!")
                print(error!.localizedDescription)
            }
        }
    }
    
    func openGC() {
        let gcVC = GKGameCenterViewController()
        gcVC.gameCenterDelegate = self
        gcVC.viewState = .leaderboards
        gcVC.leaderboardIdentifier = LEADERBOARD_ID
        self.present(gcVC, animated: true, completion: nil)
    }
    
    func openAbout() {
        let about = AboutController()
        about.modalTransitionStyle = .crossDissolve
        about.modalPresentationStyle = .overCurrentContext
        present(about, animated: true, completion: nil)
    }

    override var shouldAutorotate: Bool {
        return false
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
