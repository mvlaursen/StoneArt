//
//  ViewController.swift
//  StoneArt
//
//  Created by Mike Laursen on 8/28/19.
//  Copyright © 2019 Appamajigger. All rights reserved.
//

import CoreData
import UIKit

class ViewController: UIViewController {
    static let kBoardViewTag = 100
    static let kPrivacyPolicyUrl = "https://mvlaursen.github.io/GoStoneArt"
    
    var game = Game()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        boardView.addMoveCallback = self.addMove
        game.fetchSavedGame(persistentContext: persistentContext())
        setBoardForBoardView()
    }

    @IBAction func privacyPolicy(_ sender: UIButton) {
        if let url = URL(string: ViewController.kPrivacyPolicyUrl) {
            UIApplication.shared.open(url)
        }
    }
    
    @IBAction func newGame(_ sender: UIButton) {
        Game.deleteSavedGames(persistentContext: persistentContext())
        self.game = Game()
        setBoardForBoardView()
        boardView.resetForNewGame()
    }
    
    @IBAction func undoMove(_ sender: UIButton) {
        self.game.undoMostRecentMove()
        game.saveGame(persistentContext: persistentContext())
        setBoardForBoardView()
    }
    
    // MARK: Callbacks
    
    func addMove(index: Int, square: Square) {
        self.game.addMove(index: index, square: square)
        game.saveGame(persistentContext: persistentContext())
        setBoardForBoardView()
    }
    
    // MARK: Utility
    
    private var boardView: BoardView {
        get {
            guard let boardView = self.view.viewWithTag(ViewController.kBoardViewTag) as? BoardView else {
                fatalError("BoardView should be in view hierarchy.")
            }
            return boardView
        }
    }
    
    private func persistentContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        return context
    }

    private func setBoardForBoardView() {
        guard let board: Board = self.game.moves.last else {
            fatalError("Board should always have at least one move.")
        }
        boardView.setBoard(board)
    }
}
