//
//  BoardView.swift
//  StoneArt
//
//  Created by Mike Laursen on 8/29/19.
//  Copyright © 2019 Appamajigger. All rights reserved.
//

import SpriteKit
import UIKit

class BoardView: SKView {
    class BoardNode: SKSpriteNode {
    }
    
    override func layoutSubviews() {
        if self.scene == nil {
            let scene = SKScene(size: self.bounds.size)
            
            let board = BoardNode(imageNamed: "GomokuBoard1024")
            scene.addChild(board)
            self.presentScene(scene)
        }
    }}
