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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        boardView.addMoveCallback = self.addMove
        fetchSavedGame()
        setBoardForBoardView()
    }

    @IBAction func newGame(_ sender: UIButton) {
        deleteSavedGames()
        self.game = Game()
        setBoardForBoardView()
        boardView.resetForNewGame()
    }
    
    @IBAction func undoMove(_ sender: UIButton) {
        self.game.undoMostRecentMove()
        // TODO: This is pretty brute force. Should be able to undo one move from SavedGame.
        saveGame()
        setBoardForBoardView()
    }
    
    // MARK: Callbacks
    
    func addMove(index: Int, square: Square) {
        self.game.addMove(index: index, square: square)
        // TODO: This is pretty brute force. Should be able to add one move to SavedGame.
        saveGame()
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
        
    // MARK: Persistence

    func deleteSavedGames() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        do {
            let savedGames: [Any] = try context.fetch(NSFetchRequest<NSFetchRequestResult>(entityName: "SavedGame"))
            savedGames.forEach({ (element) in
                if let nsmo = element as? NSManagedObject {
                    context.delete(nsmo)
                }
            })
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }

    }
    
    func fetchSavedGame() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        do {
            let savedGames: [Any] = try context.fetch(NSFetchRequest<NSFetchRequestResult>(entityName: "SavedGame"))

            assert((0...1).contains(savedGames.count))
            if savedGames.count > 0 {
                if let savedGame = savedGames.first as? SavedGame {
                    var serialization: [[String]] = []
                    if let moves = savedGame.moves {
                        for savedBoard in moves {
                            var strings: [String] = []
                            if let squares = savedBoard.squares {
                                for s in squares {
                                    strings.append(s)
                                }
                                serialization.append(strings)
                            }
                        }
                    }
                    
                    self.game.deserialize(moves: serialization)
                }
            }
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }

    func saveGame() {
        deleteSavedGames()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let edGame = NSEntityDescription.entity(forEntityName: "SavedGame", in: context)
        let savedGame = SavedGame(entity: edGame!, insertInto: context)
        let serialization: [[String]] = game.serialize()
        
        let edBoard = NSEntityDescription.entity(forEntityName: "SavedBoard", in: context)
        
        for outer in serialization {
            let savedBoard = SavedBoard(entity: edBoard!, insertInto: context)
            for inner in outer {
                if savedBoard.squares == nil {
                    savedBoard.squares = []
                }
                savedBoard.squares?.append(inner)
            }
            if savedGame.moves == nil {
                savedGame.moves = []
            }
            savedGame.moves?.append(savedBoard)
        }
    }
}

