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
            let entities = try context.fetch(NSFetchRequest<NSFetchRequestResult>(entityName: "SavedGame"))
            entities.forEach({ (entity) in
                guard let managedObject = entity as? NSManagedObject else {
                    preconditionFailure()
                    return
                }
                context.delete(managedObject)
            })
        } catch {
            // TODO: Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }

    }
    
    func fetchSavedGame(persistentContext context: NSManagedObjectContext) {
        do {
            let entities = try context.fetch(NSFetchRequest<NSFetchRequestResult>(entityName: "SavedGame"))

            assert((0...1).contains(entities.count))
            if entities.count > 0 {
                guard let savedGame = entities.first as? SavedGame, let moves = savedGame.moves else {
                    preconditionFailure()
                    return
                }

                var movesAsStrings: [[String]] = []
                for move in moves {
                    guard let savedBoard = move as? SavedBoard, let squares = savedBoard.squares else {
                        preconditionFailure()
                        return
                    }
                        
                    var squaresAsStrings: [String] = []
                    for squareAsString in squares {
                        squaresAsStrings.append(squareAsString)
                    }
                    movesAsStrings.append(squaresAsStrings)
                }
                
                self.deserialize(moves: movesAsStrings)
            }
        } catch {
            // TODO: Replace this implementation with code to handle the error appropriately.
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
