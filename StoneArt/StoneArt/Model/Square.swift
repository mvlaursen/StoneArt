//
//  Square.swift
//  StoneArt
//
//  Created by Mike Laursen on 9/2/19.
//  Copyright © 2019 Appamajigger. All rights reserved.
//

enum Square: String, CaseIterable {
    case empty = "empty"
    case black = "Black"
    case white = "White"
    case red = "Red"
    case orange = "Orange"
    case yellow = "Yellow"
    case brown = "Brown"
    case green = "Green"
    case cyan = "Cyan"
    case blue = "Blue"
    case magenta = "Magenta"
    
    static func fromString(_ s: String) -> Square {
        var square: Square = .empty
        
        let matches = Square.allCases.filter({ (square) -> Bool in
            square.rawValue == s })
        if matches.count > 0 {
            assert(matches.count == 1)
            square = matches[0]
        }
        
        return square
    }
}
