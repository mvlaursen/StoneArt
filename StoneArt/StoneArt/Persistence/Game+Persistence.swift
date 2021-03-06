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
                    fatalError("Fetched entity is not an NSManagedObject.")
                }
                context.delete(managedObject)
            })
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error fetching SavedGame entities: \(nserror), \(nserror.userInfo)")
        }

    }
    
    func fetchSavedGame(persistentContext context: NSManagedObjectContext) {
        do {
            let entities = try context.fetch(NSFetchRequest<NSFetchRequestResult>(entityName: "SavedGame"))

            assert((0...1).contains(entities.count))
            if entities.count > 0 {
                guard let savedGame = entities.first as? SavedGame, let moves = savedGame.moves else {
                    fatalError("Fetched entity is not a SavedGame or has no 'moves' relationship.")
                }

                var movesAsStrings: [[String]] = []
                for move in moves {
                    guard let savedBoard = move as? SavedBoard, let squares = savedBoard.squares else {
                        fatalError("Entity is not a SavedBoard or has no 'squares' attribute.")
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
            let nserror = error as NSError
            assertionFailure("Unresolved error fetching SavedGame entities: \(nserror), \(nserror.userInfo)")
        }
    }

    func saveGame(persistentContext context: NSManagedObjectContext) {
        Game.deleteSavedGames(persistentContext: context)
        
        guard let entityDescriptionSavedGame = NSEntityDescription.entity(forEntityName: "SavedGame", in: context) else {
            assertionFailure("NSEntityDescription for SavedGame is nil.")
            return
        }
        let savedGame = SavedGame(entity: entityDescriptionSavedGame, insertInto: context)
        let movesAsStrings: [[String]] = self.serialize()
        
        let savedBoards: NSMutableOrderedSet = []
        for squaresAsStrings in movesAsStrings {
            guard let entityDescriptionSavedBoard = NSEntityDescription.entity(forEntityName: "SavedBoard", in: context) else {
                assertionFailure("NSEntityDescription for SavedBoard is nil.")
                return
            }
            
            let savedBoard = SavedBoard(entity: entityDescriptionSavedBoard, insertInto: context)
            if savedBoard.squares == nil {
                savedBoard.squares = []
            }
            precondition(savedBoard.squares != nil)
            for squareAsString in squaresAsStrings {
                savedBoard.squares?.append(squareAsString)
            }
            savedBoards.add(savedBoard)
        }
        savedGame.moves = savedBoards
    }
}
