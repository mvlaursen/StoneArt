//
//  Game+Persistence.swift
//  StoneArt
//
//  Created by Mike Laursen on 12/9/19.
//  Copyright © 2019 Appamajigger. All rights reserved.
//

import CoreData
import Foundation

extension Game {
    static func deleteSavedGames(persistentContext context: NSManagedObjectContext) {
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
    
    func fetchSavedGame(persistentContext context: NSManagedObjectContext) {
        do {
            let savedGames = try context.fetch(NSFetchRequest<NSFetchRequestResult>(entityName: "SavedGame"))

            assert((0...1).contains(savedGames.count))
            if savedGames.count > 0 {
                if let savedGame = savedGames.first as? SavedGame {
                    var serialization: [[String]] = []
                    if let moves = savedGame.moves {
                        for savedBoard in moves {
                            guard let savedBoard = savedBoard as? SavedBoard else {
                                assertionFailure()
                                return // TODO Work on this.
                            }
                            var strings: [String] = []
                            if let squares = savedBoard.squares {
                                for s in squares {
                                    strings.append(s)
                                }
                                serialization.append(strings)
                            }
                    
                            self.deserialize(moves: serialization)
                        }
                    }
                }
            }
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }

    func saveGame(persistentContext context: NSManagedObjectContext) {
        Game.deleteSavedGames(persistentContext: context)
        
        let edGame = NSEntityDescription.entity(forEntityName: "SavedGame", in: context)
        let savedGame = SavedGame(entity: edGame!, insertInto: context)
        let serialization: [[String]] = self.serialize()
        
        let moves: NSMutableOrderedSet = []
        for outer in serialization {
            let edBoard = NSEntityDescription.entity(forEntityName: "SavedBoard", in: context)
            let savedBoard = SavedBoard(entity: edBoard!, insertInto: context)
            for inner in outer {
                if savedBoard.squares == nil {
                    savedBoard.squares = []
                }
                savedBoard.squares?.append(inner)
            }
            moves.add(savedBoard)
        }
        savedGame.moves = moves
    }
}
