//
//  Board.swift
//  Thirteen
//
//  Created by Wilhelm Thieme on 20/03/2020.
//  Copyright © 2020 Wilhelm Thieme. All rights reserved.
//

import Foundation

fileprivate let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("currentBoard.json")

class Board: Codable {
    private final var squares: [IndexPath: Square]
    class var rows: Int { fatalError() }
    class var columns: Int { fatalError() }
    final class var indexes: [IndexPath] { return (0..<rows).flatMap { r in (0..<columns).map { c in IndexPath(row: r, section: c) }  } }
    
    final var count: Int { return squares.count }
    private(set) final var score: Int = 0
    
    private(set) final subscript(_ i: IndexPath) -> Square? {
        get { return squares[i] }
        set { squares[i] = newValue }
    }
    
    static func load(fresh: Bool = false) -> Board {
        do {
            if fresh { throw NSError() }
            let data = try Data(contentsOf: url, options: .mappedIfSafe)
            let obj = try JSONDecoder().decode(Self.self, from: data)
            try Self.indexes.forEach { if !obj.contains($0) { throw NSError() } }
            return obj
        } catch {
            return Self.init()
        }
    }
    
    required internal init() {
        squares = Dictionary(uniqueKeysWithValues: Self.indexes.map { ($0, Square()) })
        squares.forEach { $0.value.value = newValueAndAddScore() }
        save()
    }
    
    private final func save() {
        guard let data = try? JSONEncoder().encode(self) else { return }
        try? data.write(to: url, options: .atomicWrite)
    }
    
    final func contains(_ indexPath: IndexPath) -> Bool {
        return squares.keys.contains(indexPath)
    }
    
    final func sumPositions(_ indexPaths: [IndexPath]) {
        var paths = indexPaths
        let last = paths.removeLast()
        let sum = reduce(indexPaths)
        self[last]?.value = sum
        paths.forEach { self[$0]?.value = newValueAndAddScore() }
        save()
    }
    
    final func popIndexPath(_ indexPath: IndexPath) {
        guard self[indexPath]?.value == 13 else { return }
        score += 13
        self[indexPath]?.rank += 1
        self[indexPath]?.value = newValueAndAddScore()
        save()
    }
    
    final func newValueAndAddScore() -> Int {
        let value = newValue()
        score += score(for: value)
        return value
    }
    
    func newValue() -> Int {
        fatalError()
    }
    
    func reduce(_ values: [IndexPath]) -> Int {
        fatalError()
    }
    
    func score(for value: Int) -> Int {
        fatalError()
    }
    
    var isGameOver: Bool {
        fatalError()
    }
    
    func canAdd(indexPath: IndexPath, to selection: [IndexPath]) -> Bool {
        fatalError()
    }
    
}
