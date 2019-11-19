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
        if let boardView = boardView {
            guard let board: Board = game.moves.last else {
                preconditionFailure()
            }
            boardView.setBoard(board)
        }
    }

    @IBAction func newGame(_ sender: UIButton) {
        print("*** New ***")
//        if let boardView = boardView {
//            game = Game()
//            boardView.board = game.moves.last
//        }
    }
    
    @IBAction func undoMove(_ sender: UIButton) {
        print("*** Undo ***")
    }
    
    // Utility
    
    private var boardView: BoardView? {
        get {
            return self.view.viewWithTag(ViewController.kBoardViewTag) as? BoardView
        }
    }
}

