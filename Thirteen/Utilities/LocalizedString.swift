//
//  LocalizedString.swift
//  Thirteen
//
//  Created by Wilhelm Thieme on 20/03/2020.
//  Copyright © 2020 Wilhelm Thieme. All rights reserved.
//

import Foundation

func localizedString(_ key: String, _ options: String...) -> String {
    var string = NSLocalizedString(key, comment: "")
    (0..<options.count).forEach { string = string.replacingOccurrences(of: "%\($0)", with: options[$0]) }
    return string
}

func localizedDate(_ date: Date, dateStyle: DateFormatter.Style, timeStyle: DateFormatter.Style) -> String {
    let formatter = DateFormatter()
    formatter.formatterBehavior = .behavior10_4
    formatter.dateStyle = dateStyle
    formatter.timeStyle = timeStyle
    
    formatter.locale = Locale.current
    return formatter.string(from: date)
}

func localizedNumber(_ int: Int) -> String {
    if int >= 1000000 {
        return String(format: "%.1fM", locale: Locale.current, Float(int)/1000000).replacingOccurrences(of: ".0", with: "")
    }
    if int >= 1000 {
        return String(format: "%.1fK", locale: Locale.current, Float(int)/1000).replacingOccurrences(of: ".0", with: "")
    }
    return "\(int)"
}
