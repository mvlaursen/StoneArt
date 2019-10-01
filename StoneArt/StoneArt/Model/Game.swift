//
//  Game.swift
//  StoneArt
//
//  Created by Mike Laursen on 9/2/19.
//  Copyright © 2019 Appamajigger. All rights reserved.
//

class Game {
    var moves = [Board.init()]
    
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
