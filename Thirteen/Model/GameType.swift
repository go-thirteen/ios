//
//  GameType.swift
//  Thirteen
//
//  Created by Wilhelm Thieme on 20/10/2020.
//  Copyright © 2020 Wilhelm Thieme. All rights reserved.
//

import Foundation

enum GameType: String, CaseIterable {
    case classic
    case hardcore
    case big
    
    
    var boardType: Board.Type {
        switch self {
        case .classic: return ClassicBoard.self
        case .hardcore: return HardcoreBoard.self
        case .big: return BigBoard.self
        }
    }
    
    var localizedTitle: String { return localizedString("\(rawValue)GameType")}
    
    var highscore: Int {
        get { UserDefaults.standard.integer(forKey: "\(rawValue)Highscore") }
        set { UserDefaults.standard.set(newValue, forKey: "\(rawValue)Highscore")}
    }
    
    static var current: GameType {
        get { GameType(rawValue: UserDefaults.standard.string(forKey: "currentGametype") ?? "") ?? .classic }
        set { UserDefaults.standard.set(newValue.rawValue, forKey: "currentGametype") }
    }
    
}
