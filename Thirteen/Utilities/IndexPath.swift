//
//  IndexPath.swift
//  Thirteen
//
//  Created by Wilhelm Thieme on 20/10/2020.
//  Copyright © 2020 Wilhelm Thieme. All rights reserved.
//

import Foundation

infix operator --
infix operator +-
infix operator -|
infix operator +|

extension IndexPath {
    
    static func -(rhs: IndexPath, lhs: IndexPath) -> IndexPath {
        return IndexPath(row: rhs.row - lhs.row, section: rhs.section - lhs.section)
    }
    
    static func +(rhs: IndexPath, lhs: IndexPath) -> IndexPath {
        return IndexPath(row: rhs.row + lhs.row, section: rhs.section + lhs.section)
    }
    
    //MARK: horizontal
    
    static func --(rhs: IndexPath, lhs: Int) -> IndexPath {
        return IndexPath(row: rhs.row, section: rhs.section - lhs)
    }
    
    static func --(rhs: Int, lhs: IndexPath) -> IndexPath {
        return IndexPath(row: lhs.row, section: rhs - lhs.section )
    }
    
    static func +-(rhs: IndexPath, lhs: Int) -> IndexPath {
        return IndexPath(row: rhs.row, section: rhs.section + lhs)
    }
    
    static func +-(rhs: Int, lhs: IndexPath) -> IndexPath {
        return IndexPath(row: lhs.row, section: rhs + lhs.section )
    }
    
    //MARK: Vertical
    
    static func -|(rhs: IndexPath, lhs: Int) -> IndexPath {
        return IndexPath(row: rhs.row - lhs, section: rhs.section)
    }
    
    static func -|(rhs: Int, lhs: IndexPath) -> IndexPath {
        return IndexPath(row: rhs - lhs.row, section: lhs.section )
    }
    
    static func +|(rhs: IndexPath, lhs: Int) -> IndexPath {
        return IndexPath(row: rhs.row + lhs, section: rhs.section)
    }
    
    static func +|(rhs: Int, lhs: IndexPath) -> IndexPath {
        return IndexPath(row: rhs + lhs.row, section: lhs.section )
    }
    
    func position(to indexPath: IndexPath) -> CompareOptions {
        let r = row - indexPath.row
        let s = section - indexPath.section
        if r == -1 && s == -1 { return .topLeft }
        else if r == -1 && s == 0 { return  .left }
        else if r == -1 && s == 1 { return  .bottomLeft }
        else if r == 0 && s == -1 { return  .top }
        else if r == 0 && s == 0 { return  .same }
        else if r == 0 && s == 1 { return  .bottom }
        else if r == 1 && s == -1 { return  .topRight }
        else if r == 1 && s == 0 { return  .right }
        else if r == 1 && s == 1 { return  .bottomRight }
        else { return .nonAdjecent }
    }
    
    func isPosition(_ options: CompareOptions, to indexPath: IndexPath) -> Bool {
        let option = position(to: indexPath)
        return options.contains(option)
    }
    
    struct CompareOptions: OptionSet {
        let rawValue: Int
        
        static let left = CompareOptions(rawValue: 1 << 0)
        static let right = CompareOptions(rawValue: 1 << 1)
        static let horizontal: CompareOptions = [.left, .right]
        static let top = CompareOptions(rawValue: 1 << 2)
        static let bottom = CompareOptions(rawValue: 1 << 3)
        static let vertical: CompareOptions = [.top, .bottom]
        static let orthogonal: CompareOptions = [.horizontal, .vertical]
        static let topLeft = CompareOptions(rawValue: 1 << 4)
        static let topRight = CompareOptions(rawValue: 1 << 5)
        static let bottomLeft = CompareOptions(rawValue: 1 << 6)
        static let bottomRight = CompareOptions(rawValue: 1 << 7)
        static let diagonal: CompareOptions = [.topLeft, .topRight, .bottomLeft, .bottomRight]
        static let adjecent: CompareOptions = [.orthogonal, .diagonal]
        static let nonAdjecent = CompareOptions(rawValue: 1 << 8)
        static let same = CompareOptions(rawValue: 1 << 9)
        static let all: CompareOptions = [.adjecent, .nonAdjecent, .same]
    }
    
}

extension Array where Element == IndexPath {
    
    func isLastPosition(_ options: IndexPath.CompareOptions, to indexPath: IndexPath) -> Bool {
        guard let last = last else { return true }
        return last.isPosition(options, to: indexPath)
    }

}
