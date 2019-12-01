//
//  Game.swift
//  StoneArt
//
//  Created by Mike Laursen on 9/2/19.
//  Copyright © 2019 Appamajigger. All rights reserved.
//

import CoreData

class Game {
    var moves = [Board.init()]
    
    init() {
    }
    
    init(savedGame: SavedGame) {
        // TODO: Replace this dummy saved game restoration with the real thing.
        let board = Board(squares: Array.init(repeating: Square.blue, count: Board.kSquaresCount))
        moves = [board]
    }
    
    func addMove(index: Int, square: Square) {
        precondition(moves.count > 0)
        moves.append(Board.init(board: moves.last!, index: index, square: square))
    }
    
    func undoMostRecentMove() {
        if moves.count > 1 {
            moves.removeLast()
        }
        assert(moves.count > 0)
    }
}
