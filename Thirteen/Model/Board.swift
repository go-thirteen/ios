//
//  Board.swift
//  Thirteen
//
//  Created by Wilhelm Thieme on 20/03/2020.
//  Copyright © 2020 Wilhelm Thieme. All rights reserved.
//

import Foundation

fileprivate let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("currentBoard.json")
fileprivate let options: [(Float, Int)] = [(0.1, 1), (0.1, 2), (0.2, 3), (0.2, 4), (0.1, 5), (0.1, 6), (0.1, 7), (0.05, 8), (0.02, 9), (0.02, 10), (0.01, 11)]

struct Board: Codable {
    private var squares: [Square]
    private(set) var score: Int = 0
    var count: Int { return squares.count }
    
    subscript(i: Int) -> Square {
        get { return squares[i] }
        set { squares[i] = newValue }
    }
    
    init(_ count: Int, fresh: Bool = false) {
        squares = Array(repeating: Square(), count: count)
        
        let fillSquares = count - Int(sqrt(Double(count)))
        (0..<fillSquares).forEach { _ in fillSquare() }
        
        if fresh { return }
        guard FileManager.default.fileExists(atPath: url.absoluteString) else { return }
        guard let data = try? Data(contentsOf: url, options: .mappedIfSafe) else { return }
        guard let obj = try? JSONDecoder().decode(Self.self, from: data) else { return }
        guard obj.count == count else { return }
        self = obj
    }
    
    mutating func fillSquare() {
        guard let value = Choice.choose(from: options) else { return }
        var index = Int.random(in: 0..<count)
        while !self[index].isEmpty {
            index = Int.random(in: 0..<count)
        }
        score += value
        self[index].value = value
//        let num = arc4random_uniform(UInt32(count))
    }
    
    mutating func sumPositions(_ positions: [Int]) {
        guard let last = positions.last(where: { !self[$0].isEmpty }) else { return }
        let sum = positions.map({ self[$0].value }).reduce(0, +)
        let addSquares = positions.filter({ !self[$0].isEmpty }).count - 1
        positions.forEach { self[$0].value = 0 }
        self[last].value = sum
        (0..<addSquares).forEach { _ in fillSquare() }
    }
    
    var gameover: [Int] {
        return squares.enumerated().compactMap { $0.element.isGameover ? $0.offset : nil }
    }
    
    func save() {
        guard let data = try? JSONEncoder().encode(self) else { return }
        try? data.write(to: url, options: .atomicWrite)
    }
}
