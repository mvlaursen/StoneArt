//
//  Board.swift
//  StoneArt
//
//  Created by Mike Laursen on 9/2/19.
//  Copyright © 2019 Appamajigger. All rights reserved.
//

struct Board {
    static let kSquaresPerDim = 15
    static let kSquaresCount = Board.kSquaresPerDim * Board.kSquaresPerDim
    
    let squares: [Square]
    
    /**
     * - parameters:
     *   - row, column
     * - returns:
     *       The index in the one-dimensional "squares" array
     */
    static func indexFrom(row: Int, column: Int) -> Int {
        precondition(row >= 0 && row < Board.kSquaresPerDim)
        precondition(column >= 0 && column < Board.kSquaresPerDim)
        
        return row * Board.kSquaresPerDim + column
    }
    
    /**
     * - parameters:
     *   - index: The index in the one-dimensional "squares" array
     * - returns:
     *       A tuple containing the row and column
     */
    static func rowAndColumnFrom(index: Int) -> (row: Int, column: Int) {
        precondition(index >= 0 && index < Board.kSquaresCount)
        let row = index / Board.kSquaresPerDim
        let column = index % Board.kSquaresPerDim
        return (row: row, column: column)
    }
    
    init() {
        self.squares = Array.init(repeating: Square.empty, count: Board.kSquaresPerDim * Board.kSquaresPerDim)
    }

    init(squares: [Square]) {
        precondition(squares.count == Board.kSquaresCount)
        
        self.squares = squares
    }

    init(board other: Board, index: Int, square: Square) {
        precondition(index >= 0 && index < Board.kSquaresCount)
        
        var newSquares = other.squares
        newSquares[index] = square
        self.squares = newSquares
    }
}
