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
    
    var game = Game()
    var savedGame: SavedGame? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        boardView.addMoveCallback = self.addMove
        fetchSavedGame()
        setBoardForBoardView()
    }

    @IBAction func newGame(_ sender: UIButton) {
        self.game = Game()
        createNewSavedGame()
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
        
    func createNewSavedGame() {
        if savedGame != nil {
            deleteSavedGame()
        }
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let entityDescription = NSEntityDescription.entity(forEntityName: "SavedGame", in: context)
        savedGame = SavedGame(entity: entityDescription!, insertInto: context)
        game = Game(savedGame: savedGame!)
    }

    func deleteSavedGame() {
        savedGame = nil
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        do {
            let savedGamesAsAny = try context.fetch(NSFetchRequest<NSFetchRequestResult>(entityName: "SavedGame"))
            let savedGames = savedGamesAsAny as? [SavedGame]
            savedGames?.forEach({ (savedGame) in
                context.delete(savedGame)
            })
            try context.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }

    }
    
    func fetchSavedGame() {
        precondition(savedGame == nil)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        do {
            let savedGamesAsAny = try context.fetch(NSFetchRequest<NSFetchRequestResult>(entityName: "SavedGame"))
            let savedGames = savedGamesAsAny as? [SavedGame]
            savedGame = savedGames?.first
            
            if savedGame != nil {
                game = Game(savedGame: savedGame!)
            } else {
                game = Game()
            }
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
}

