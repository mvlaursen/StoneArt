//
//  ViewController.swift
//  StoneArt
//
//  Created by Mike Laursen on 8/28/19.
//  Copyright © 2019 Appamajigger. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    static let kBoardViewTag = 100
    
    var game = Game()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        boardView.addMoveCallback = self.addMove
        setBoardForBoardView()
    }

    @IBAction func newGame(_ sender: UIButton) {
        self.game = Game()
        setBoardForBoardView()
        boardView.resetForNewGame()
    }
    
    @IBAction func undoMove(_ sender: UIButton) {
        self.game.undoMostRecentMove()
        setBoardForBoardView()
    }
    
    // MARK: Callbacks
    
    func addMove(index: Int, square: Square) {
        self.game.addMove(index: index, square: square)
        setBoardForBoardView()
    }
    
    // MARK: Utility
    
    private var boardView: BoardView {
        get {
            guard let boardView = self.view.viewWithTag(ViewController.kBoardViewTag) as? BoardView else {
                preconditionFailure()
            }
            return boardView
        }
    }
    
    private func setBoardForBoardView() {
        guard let board: Board = self.game.moves.last else {
            preconditionFailure()
        }
        boardView.setBoard(board)
    }
}

