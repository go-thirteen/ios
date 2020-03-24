//
//  AppDelegate.swift
//  Thirteen
//
//  Created by Wilhelm Thieme on 20/03/2020.
//  Copyright © 2020 Wilhelm Thieme. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    internal var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            Defaults.appVersion.set("\(version)")
        }

        window = UIWindow()
        window?.rootViewController = ViewController()
        window?.makeKeyAndVisible()
        
        GameCenter.authenticateLocalPlayer()
        
        return true
    }


}

