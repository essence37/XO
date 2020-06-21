//
//  PlayerInputState.swift
//  XO-game
//
//  Created by Alexander Bondarenko on 15.06.2020.
//  Copyright © 2020 plasmon. All rights reserved.
//

import Foundation

public class PlayerInputState: GameState {
    
    public private(set) var isCompleted = false
    
    public let player: Player
    public let markViewPrototype: MarkView
    
    public var playerInputMoves: [GameboardPosition] = []
    public var markViewsPrototype: [MarkView] = []
    
    private(set) weak var gameViewController: GameViewController?
    private(set) weak var playerVsComputerViewController: PlayerVsComputerViewController?
    private(set) weak var gameboard: Gameboard?
    private(set) weak var gameboardView: GameboardView?
    
    private var blindStepsCount: Int = 0
    private let maxBlindStepsCount: Int = Int(ceil(Double(GameboardSize.columns*GameboardSize.rows/2)))
    
    init(player: Player, markViewPrototype: MarkView, gameViewController: GameViewController, gameboard: Gameboard, gameboardView: GameboardView) {
        self.player = player
        self.markViewPrototype = markViewPrototype
        self.gameViewController = gameViewController
        self.gameboard = gameboard
        self.gameboardView = gameboardView
    }
    
    init(player: Player, markViewPrototype: MarkView, playerVsComputerViewController: PlayerVsComputerViewController, gameboard: Gameboard, gameboardView: GameboardView) {
        self.player = player
        self.markViewPrototype = markViewPrototype
        self.playerVsComputerViewController = playerVsComputerViewController
        self.gameboard = gameboard
        self.gameboardView = gameboardView
    }
    
    public func begin() {
        switch self.player {
        case .first:
            self.gameViewController?.firstPlayerTurnLabel.isHidden = false
            self.gameViewController?.secondPlayerTurnLabel.isHidden = true
            
        case .second:
            self.gameViewController?.firstPlayerTurnLabel.isHidden = true
            self.gameViewController?.secondPlayerTurnLabel.isHidden = false
        case .player:
            self.playerVsComputerViewController?.firstPlayerTurnLabel.isHidden = false
            self.playerVsComputerViewController?.computerTurnLabel.isHidden = true
        case .computer:
            self.playerVsComputerViewController?.firstPlayerTurnLabel.isHidden = true
            self.playerVsComputerViewController?.computerTurnLabel.isHidden = false
        }
            self.gameViewController?.winnerLabel.isHidden = true
            self.playerVsComputerViewController?.winnerLabel.isHidden = true
    }
    
    public func addMark(at position: GameboardPosition) {
        
        Log(.playerInput(player: self.player, position: position))
        
        guard let gameboardView = self.gameboardView
        , gameboardView.canPlaceMarkView(at: position) else { return }
        
//        let markView: MarkView
//
//        switch self.player {
//        case .first:
//            markView = XView()
//        case .second:
//                markView = OView()
//        }
//
        self.gameboard?.setPlayer(self.player, at: position)
//        self.gameboardView?.placeMarkView(markView, at: position)
        self.gameboardView?.placeMarkView(markViewPrototype.copy(), at: position)
        self.isCompleted = true
    }
    
    public func addMarks(at position: GameboardPosition) {
        
        Log(.playerInput(player: self.player, position: position))
        
        if let gameboardView = self.gameboardView
            , gameboardView.canPlaceMarkView(at: position) {
            
//            self.gameboard?.setPlayer(self.player, at: position)
//            markViewsPrototype.append(markViewPrototype.copy())
//            playerInputMoves.append(position)
            
            let command = Command(position: position, player: self.player, gameboard: self.gameboard!, gameboardView: gameboardView)
            Invoker.shared.addCommand(command)
        } else {
            
//            self.gameboard?.clearPlayer(at: position)
//            self.gameboardView?.removeMarkView(at: position)
//            self.gameboard?.setPlayer(self.player, at: position)
//
//            markViewsPrototype.append(markViewPrototype.copy())
//            playerInputMoves.append(position)
            
            let command = Command(position: position, player: player, gameboard: self.gameboard!, gameboardView: self.gameboardView!)
            Invoker.shared.addCommand(command)
        }
        if blindStepsCount == maxBlindStepsCount {
            blindStepsCount = 0
            self.isCompleted = true
        }
        blindStepsCount += 1
    }
    
    public func showMarks(_ marksViews: [MarkView], at positions: [GameboardPosition]) {
        self.gameboardView?.placeMarksViews(marksViews, at: positions)
    }
    
    public func computerAddMark() -> GameboardPosition {
        let position = GameboardPosition(column: Int.random(in: 0...GameboardSize.columns-1),
                                         row: Int.random(in: 0...GameboardSize.rows-1))
        return position
    }
    
}
