//
//  BoardView.swift
//  StoneArt
//
//  Created by Mike Laursen on 8/29/19.
//  Copyright © 2019 Appamajigger. All rights reserved.
//

import SpriteKit
import UIKit

extension CGFloat {
    func matches(_ other: CGFloat, within tolerance: CGFloat) -> Bool {
        return abs(self - other) < tolerance
    }
}

class BoardView: SKView {
    static let kBoardZPosition = CGFloat(150.0)
    static let kStoneHaloZPosition = CGFloat(200.0)
    static let kStoneZPosition = CGFloat(250.0)
    static let kTapTolerance = CGFloat(2.5)

    let boardSceneDelegate = BoardSceneDelegate()

    // MARK: BoardMetrics

    /**
     * The images and layout dimensions we use are dependent on the current device's resolution.
     */
    struct BoardMetrics {
        let boardImageName: String
        let squareDim: CGFloat
        let blackImageName: String
        let whiteImageName: String
    }
    
    // MARK: BoardNode

    /**
     * An SKSpriteNode subclass makes it possible to use a filter to find the board's node among the
     * scene's child nodes.
     */
    class BoardNode: SKSpriteNode {
    }
    
    // MARK: BoardSceneDelegate
    
    /**
     * Handles updating of the scene, based on the data in the Board model.
     */
    class BoardSceneDelegate: NSObject, SKSceneDelegate {
        // TODO: Shouldn't create a Board just to toss it away.
        var board: Board = Board()
        var palette: Dictionary<Square, StoneNode> = [:]
        
        override init() {
            // Create palette of stones of various colors.
            
            let metrics = BoardView.boardMetrics()
            
            let blackPaletteStone = StoneNode(imageNamed: metrics.blackImageName, position: CGPoint(x: CGFloat(0) * metrics.squareDim, y: CGFloat(-Board.kSquaresPerDim) * metrics.squareDim))
            self.palette[.black] = blackPaletteStone

            let whitePaletteStone = StoneNode(imageNamed: metrics.whiteImageName, position: CGPoint(x: CGFloat(1) * metrics.squareDim, y: CGFloat(-Board.kSquaresPerDim) * metrics.squareDim))
            self.palette[.white] = whitePaletteStone

        }
        
        func makePaletteSelection(stoneNode: StoneNode) {
            palette.forEach {
                $0.value.selected = $0.value === stoneNode
            }
        }
        
        func paletteContains(stoneNode: StoneNode) -> Bool {
            palette.contains {
                $0.value === stoneNode
            }
        }
        
        func selectedSquare() -> Square {
            var square = Square.empty
            
            let selectedNodes = palette.filter {
                $0.value.selected
            }
            assert(selectedNodes.count <= 1)
            if let node = selectedNodes.first {
                assert(node.key != .empty)
                square = node.key
            }
            
            return square
        }
        
        func update(_ currentTime: TimeInterval, for scene: SKScene) {
            let boardNodes = scene.children.filter { $0.isKind(of: BoardNode.self) }
            assert(boardNodes.count <= 1)
            if boardNodes.count > 0 {
                if let boardNode = boardNodes.first {
                    let metrics = BoardView.boardMetrics()
                    boardNode.removeAllChildren()
                    
                    for row in 0..<Board.kSquaresPerDim {
                        for column in 0..<Board.kSquaresPerDim {
                            let square = board.squares[Board.indexFrom(row: row, column: column)]
                            if square == .black || square == .white {
                                let stone = StoneNode(imageNamed: square == .black ? metrics.blackImageName : metrics.whiteImageName, position: CGPoint(x: CGFloat(column) * metrics.squareDim, y: CGFloat(-row) * metrics.squareDim))
                                boardNode.addChild(stone)
                            }
                        }
                    }
                    
                    // Add stones to palette area.
                    
                    assert(palette[.black] != nil)
                    if let blackStone = palette[.black] {
                        boardNode.addChild(blackStone)
                    }
                    
                    assert(palette[.white] != nil)
                    if let whiteStone = palette[.white] {
                        boardNode.addChild(whiteStone)
                    }
                }
            }
        }
    }
    
    // MARK: StoneNode
        
    class StoneNode: SKNode {
        var imageName: String = ""
        var selectedEffectNode: SKEffectNode = SKEffectNode()

        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        init(imageNamed imageName: String, position: CGPoint) {
            super.init()
            
            self.imageName = imageName
            let backgroundImage = SKSpriteNode(imageNamed: imageName)
            backgroundImage.position = position
            backgroundImage.zPosition = BoardView.kStoneHaloZPosition

            let colorEffectNode = SKEffectNode()
            colorEffectNode.filter = CIFilter(name: "CIColorMatrix", parameters: ["inputRVector": CIVector(string: "[0 0 0 0]"), "inputGVector": CIVector(string: "[0 0 0 0]"), "inputBVector": CIVector(string: "[1 1 1 1]")])
            colorEffectNode.addChild(backgroundImage)
            
            let scaleEffectNode = SKEffectNode()
            scaleEffectNode.filter = CIFilter(name: "CILanczosScaleTransform", parameters: ["inputScale": 1.01])
            scaleEffectNode.addChild(colorEffectNode)

            selectedEffectNode.alpha = 0.0
            selectedEffectNode.filter = CIFilter(name: "CIGaussianBlur")
            selectedEffectNode.addChild(scaleEffectNode)
            self.addChild(selectedEffectNode)
            
            let foregroundImage = SKSpriteNode(imageNamed: imageName)
            foregroundImage.position = position
            foregroundImage.zPosition = BoardView.kStoneZPosition
            self.addChild(foregroundImage)
        }
        
        var selected: Bool {
            get {
                return selectedEffectNode.alpha > 0.0
            }
            set {
                selectedEffectNode.alpha = newValue ? 1.0 : 0.0
            }
        }
    }
    
    static func boardMetrics() -> BoardMetrics {
        let size = UIScreen.main.bounds.size
        let width = min(size.width, size.height)
        
        if width.isEqual(to: 375.0) {
            return BoardMetrics(boardImageName: "StoneArtBoard368", squareDim: 23.0, blackImageName: "BlackStone21", whiteImageName: "WhiteStone21")
        } else if width.isEqual(to: 768.0) {
            return BoardMetrics(boardImageName: "StoneArtBoard768", squareDim: 48.0, blackImageName: "BlackStone45", whiteImageName: "WhiteStone45")
        } else if width.isEqual(to: 414.0) {
            return BoardMetrics(boardImageName: "StoneArtBoard400", squareDim: 25.0, blackImageName: "BlackStone23", whiteImageName: "WhiteStone23")
        } else if width.isEqual(to: 1024.0) {
            return BoardMetrics(boardImageName: "StoneArtBoard1024", squareDim: 64.0, blackImageName: "BlackStone60", whiteImageName: "WhiteStone60")
        } else if width.isEqual(to: 834.0) {
            return BoardMetrics(boardImageName: "StoneArtBoard768", squareDim: 48.0, blackImageName: "BlackStone45", whiteImageName: "WhiteStone45")
        } else {
            return BoardMetrics(boardImageName: "StoneArtBoard320", squareDim: 20.0, blackImageName: "BlackStone18", whiteImageName: "WhiteStone18")
        }
    }
    
    func boardNode() -> BoardNode? {
        let boardNodes = self.scene?.children.filter { $0.isKind(of: BoardNode.self) }
        if let boardNode = boardNodes?.first as? BoardNode {
            return boardNode
        } else {
            return nil
        }
    }

    // MARK: Model Access
    
    func setBoard(_ board: Board) {
        self.boardSceneDelegate.board = board
    }

    // MARK: Layout

    override func layoutSubviews() {
        if self.scene == nil {
            let metrics = BoardView.boardMetrics()
            let scene = SKScene(size: self.bounds.size)
            scene.backgroundColor = SKColor.clear
            scene.delegate = self.boardSceneDelegate
            
            // To make conversion from the location of a tap in the scene's
            // coordinate system to board row and column as straightforward as
            // possible, align row 0, column 0 of the board image with the
            // scene's origin. There is still the difference that the scene's
            // y-axis points up while row numbers increase from top to bottom
            // of the board, but aligning row 0 with y = 0 allows us to simply
            // negate the value of y when converting.
            
            let boardNode = BoardNode(imageNamed: metrics.boardImageName)
            
            let squareDimInUnitSpace = 1.0 / CGFloat(Board.kSquaresPerDim + 1)
            boardNode.anchorPoint = CGPoint(x: squareDimInUnitSpace, y: 1 - squareDimInUnitSpace)
            
            // If our collection of artwork is done correctly, the board images
            // always fit within the available screen space. The board image
            // has a palette area at the bottom where the user grabs new
            // stones to place; it has a height of one squareDim.
            let xMargin = (scene.size.width - boardNode.size.width) / 2.0
            let yMargin = (scene.size.height - boardNode.size.height) / 2.0
            let yPalette = metrics.squareDim
            boardNode.position = CGPoint(x: xMargin + metrics.squareDim, y: yMargin + CGFloat(Board.kSquaresPerDim) * metrics.squareDim + yPalette)
            boardNode.zPosition = BoardView.kBoardZPosition
            
            scene.addChild(boardNode)
            
            // Start the show!

            self.presentScene(scene)
        }
    }
    
    // MARK: Gesture Handling
    
    /**
     * - parameter for: Should be in the SKScene's coordinate system.
     */
    private func moveIndex(for location: CGPoint) -> Int? {
        var retVal: Int? = nil
        
        print("moveIndex: location.x, .y: \(location.x), \(location.y)")
        
        let metrics = BoardView.boardMetrics()
        
        // Convert the location of the tap to a row and column on the board.
        //
        // However, only return the row and column if the tap is not ambiguous
        // (i.e. the tap is halfway between two rows or two columns, or the tap
        // is in the board's margin). To check for ambiguity, reverse engineer
        // the x and y coordinates of the tap from the row and column, then
        // test if the reverse-engineered x and y are close to the tap location
        // that was passed in.
        
        let column = Int(round(location.x / metrics.squareDim))
        if column >= 0 && column < Board.kSquaresPerDim {
            let xFromColumn = CGFloat(column) * metrics.squareDim
            
            if xFromColumn.matches(location.x, within: metrics.squareDim / BoardView.kTapTolerance) {
                let row = Int(round(-location.y / metrics.squareDim))
                if row >= 0 && row < Board.kSquaresPerDim {
                    let yFromRow = CGFloat(-row) * metrics.squareDim
                
                    if yFromRow.matches(location.y, within: metrics.squareDim / BoardView.kTapTolerance) {
                        print("    x, y: \(xFromColumn), \(yFromRow)")
                        print("    row, column: \(row), \(column)")
                        retVal = Board.indexFrom(row: row, column: column)
                    }
                }
            }
        }
        
        return retVal
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let boardNode = boardNode(), let scene = self.scene, let touch = touches.first else {
            return
        }
            
        let location = touch.location(in: scene)
        let nodes = scene.nodes(at: location)
        let stones = nodes.filter { $0.isKind(of: BoardView.StoneNode.self) }
        // If our code is working correctly, there should never be more
        // than one stone in the same spot on the board.
        assert(stones.count <= 1)
        
        if let moveIndex = moveIndex(for: touch.location(in: boardNode)) {
            if stones.isEmpty {
                let squareToAdd = self.boardSceneDelegate.selectedSquare()
                    if squareToAdd != .empty {
                        self.boardSceneDelegate.board = Board(board: self.boardSceneDelegate.board, index: moveIndex, square: squareToAdd)
                    }
            } else {
                self.boardSceneDelegate.board = Board(board: self.boardSceneDelegate.board, index: moveIndex, square: .empty)
            }
        } else {
            if let stoneNode = stones.first {
                if let stoneNode = stoneNode as? StoneNode {
                    if self.boardSceneDelegate.paletteContains(stoneNode: stoneNode) {
                        self.boardSceneDelegate.makePaletteSelection(stoneNode: stoneNode)
                    }
                }
            }
        }
    }
}

