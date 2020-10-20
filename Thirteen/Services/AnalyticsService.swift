//
//  Analytics.swift
//  Beatz
//
//  Created by Wilhelm Thieme on 07/09/2020.
//  Copyright © 2020 wjthieme. All rights reserved.
//

import UIKit
import Firebase

class AnalyticsService {
    
    static func log(_ error: Error) {
        #if DEBUG
        print(error)
        Thread.callStackSymbols.forEach { print($0) }
        #else
        Crashlytics.crashlytics().record(error: error)
        #endif
    }
}
