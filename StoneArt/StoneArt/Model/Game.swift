//
//  Game.swift
//  StoneArt
//
//  Created by Mike Laursen on 9/2/19.
//  Copyright © 2019 Appamajigger. All rights reserved.
//

class Game {
    var moves = [Board.init()]
    
    init() {
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
    
    // MARK: Serialization

    func deserialize(moves: [[String]]) {
        self.moves.removeAll()
        
        for move in moves {
            var squares: [Square] = []
            
            for s in move {
                squares.append(Square.fromString(s))
            }
            
            assert(squares.count == Board.kSquaresCount)
            let board = Board(squares: squares)
            self.moves.append(board)
        }
    }

    func serialize() -> [[String]] {
        var moves: [[String]] = []
        
        for move in self.moves {
            var squares: [String] = []
            
            for square in move.squares {
                squares.append(square.rawValue)
            }
            
            assert(squares.count == Board.kSquaresCount)
            moves.append(squares)
        }
        
        return moves
    }
}
