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
import GoogleMobileAds

class GameViewController: UIViewController, GKGameCenterControllerDelegate, GADInterstitialDelegate {
    
    var gcEnabled = Bool()
    var gcDefaultLeaderBoard = String()
    
    let LEADERBOARD_ID = "com.wjthieme.Thirteen"
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    var gameScene: GameScene?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        #if DEBUG
            UserDefaults.standard.set(false, forKey: Keys.openedBefore)
        #endif
        
        authenticateLocalPlayer()
    
        
        if let view = self.view as! SKView? {
            gameScene = GameScene(rect: self.view.frame)
            gameScene?.scaleMode = .aspectFit
            view.presentScene(gameScene!)
            view.ignoresSiblingOrder = true
        }
        
        configureAd()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !UserDefaults.standard.bool(forKey: Keys.openedBefore) {
            openTutorial()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let scene = gameScene {
            scene.isPaused = false
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if let scene = gameScene {
            scene.isPaused = true
        }
    }
    
    func updateGC(_ score: Int) {
        if gcEnabled {
            let scoreObj = GKScore(leaderboardIdentifier: LEADERBOARD_ID)
            scoreObj.value = Int64(score)
            GKScore.report([scoreObj]) { (error) in
                if error != nil {
                    print(error!.localizedDescription)
                }
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
    
    func openSettings() {
        let settings = SettingsController()
        let naviController = UINavigationController(rootViewController: settings)
        naviController.modalTransitionStyle = .coverVertical
        naviController.modalPresentationStyle = .currentContext
        present(naviController, animated: true, completion: nil)
    }
    
    func openTutorial() {
        let tut = TutorialController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        let naviController = UINavigationController(rootViewController: tut)
        naviController.modalTransitionStyle = .coverVertical
        naviController.modalPresentationStyle = .currentContext
        present(naviController, animated: true, completion: nil)
    }
    
    var interstitial: GADInterstitial?
    
    func configureAd() {
        
        #if DEBUG
            interstitial = GADInterstitial(adUnitID: "ca-app-pub-3940256099942544/4411468910")
        #else
            interstitial = GADInterstitial(adUnitID: "ca-app-pub-7877293326290287/9674219782")
        #endif
        
        interstitial?.delegate = self
        interstitial?.load(GADRequest())
    }
    
    var openAdASAP = false
    func interstitialDidReceiveAd(_ ad: GADInterstitial) {
        if openAdASAP {
            openAd()
            openAdASAP = false
        }
    }
    
    func openAd() {
        guard let inter = interstitial, !UserDefaults.standard.bool(forKey: Keys.adsDisabled) else {
            return
        }
        if inter.isReady {
            inter.present(fromRootViewController: self)
        } else {
            openAdASAP = true
        }
    }
    
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        configureAd()
    }

    override var shouldAutorotate: Bool {
        return false
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
}
