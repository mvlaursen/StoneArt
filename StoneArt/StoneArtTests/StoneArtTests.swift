//
//  StoneArtTests.swift
//  StoneArtTests
//
//  Created by Mike Laursen on 8/28/19.
//  Copyright © 2019 Appamajigger. All rights reserved.
//

import XCTest
@testable import StoneArt

class StoneArtTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testGameInit() {
        let game = Game.init()
        XCTAssertEqual(game.moves.count, 1)
        XCTAssertTrue(game.moves[0].squares.allSatisfy({ (square) -> Bool in
            square == Square.empty
        }))
    }
    
    func testGameAddMove() {
        let game = Game.init()
        game.addMove(index: 0, square: Square.black)
        game.addMove(index: 1, square: Square.white)

        XCTAssertEqual(game.moves.count, 3)

        XCTAssertTrue(game.moves[0].squares.allSatisfy({ (square) -> Bool in
            square == Square.empty
        }))
        
        XCTAssertTrue(game.moves[1].squares[0] == Square.black)
        XCTAssertTrue(game.moves[1].squares[1...].allSatisfy({ (square) -> Bool in
            square == Square.empty
        }))
        
        XCTAssertTrue(game.moves[2].squares[0] == Square.black)
        XCTAssertTrue(game.moves[2].squares[1] == Square.white)
        XCTAssertTrue(game.moves[1].squares[2...].allSatisfy({ (square) -> Bool in
            square == Square.empty
        }))
    }
    
    func testGameUndoMove() {
        let game = Game.init()
        XCTAssertEqual(game.moves.count, 1)
        game.addMove(index: Int.random(in: 0..<Board.kSquaresCount), square: Square.black)
        XCTAssertEqual(game.moves.count, 2)
        game.addMove(index: Int.random(in: 0..<Board.kSquaresCount), square: Square.black)
        XCTAssertEqual(game.moves.count, 3)
        game.addMove(index: Int.random(in: 0..<Board.kSquaresCount), square: Square.black)
        XCTAssertEqual(game.moves.count, 4)
        game.undoMostRecentMove()
        XCTAssertEqual(game.moves.count, 3)
        game.undoMostRecentMove()
        XCTAssertEqual(game.moves.count, 2)
        game.undoMostRecentMove()
        XCTAssertEqual(game.moves.count, 1)
        game.undoMostRecentMove()
        XCTAssertEqual(game.moves.count, 1)
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
