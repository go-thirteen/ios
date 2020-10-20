//
//  Board.swift
//  Thirteen
//
//  Created by Wilhelm Thieme on 20/03/2020.
//  Copyright © 2020 Wilhelm Thieme. All rights reserved.
//

import Foundation

fileprivate let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("currentBoard.json")

class Board: Codable, FromSelf {
    private final var squares: [IndexPath: Square]
    class var rows: Int { return 0 }
    class var columns: Int { return 0 }
    final class var indexes: [IndexPath] { return (0..<rows).flatMap { r in (0..<columns).map { c in IndexPath(row: r, section: c) }  } }
    
    final var count: Int { return squares.count }
    private(set) final var score: Int = 0
    
    private(set) final subscript(_ i: IndexPath) -> Square? {
        get { return squares[i] }
        set { squares[i] = newValue }
    }
    
    required convenience init(fresh: Bool = false) {
        do {
            if fresh { throw NSError() }
            let data = try Data(contentsOf: url, options: .mappedIfSafe)
            let obj = try JSONDecoder().decode(Self.self, from: data)
            print(String(data: data, encoding: .utf8)!)
            try Self.indexes.forEach { if !obj.contains($0) { throw NSError() } }
            self.init(from: obj)
        } catch {
            self.init()
        }
    }
    
    private init() {
        squares = Dictionary(uniqueKeysWithValues: Self.indexes.map { ($0, Square()) })
        squares.forEach { $0.value.value = newValueAndAddScore() }
        save()
    }
    
    final func contains(_ indexPath: IndexPath) -> Bool {
        return squares.keys.contains(indexPath)
    }
    
    final func save() {
        guard let data = try? JSONEncoder().encode(self) else { return }
        try? data.write(to: url, options: .atomicWrite)
    }
    
    final func sumPositions(_ indexPaths: [IndexPath]) {
        var paths = indexPaths
        let last = paths.removeLast()
        let sum = reduce(indexPaths)
        self[last]?.value = sum == 13 ? newValueAndAddScore() : sum
        if sum == 13 { score += 13 }
        paths.forEach { self[$0]?.value = newValueAndAddScore() }
    }
    
    final func newValueAndAddScore() -> Int {
        let value = newValue()
        score += score(for: value)
        return value
    }
    
    func reduce(_ values: [IndexPath]) -> Int {
        return 0
    }

    
    func newValue() -> Int {
        return 0
    }
    
    func score(for value: Int) -> Int {
        return 0
    }
    
    var isGameOver: Bool {
       return false
    }
    
    func canAdd(indexPath: IndexPath, to selection: [IndexPath]) -> Bool {
        return true
    }
    
}
