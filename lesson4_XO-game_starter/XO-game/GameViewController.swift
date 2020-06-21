//
//  GameViewController.swift
//  XO-game
//
//  Created by Evgeny Kireev on 25/02/2019.
//  Copyright © 2019 plasmon. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {

    @IBOutlet var gameboardView: GameboardView!
    @IBOutlet var firstPlayerTurnLabel: UILabel!
    @IBOutlet var secondPlayerTurnLabel: UILabel!
    @IBOutlet var winnerLabel: UILabel!
    @IBOutlet var restartButton: UIButton!
    @IBOutlet weak var gameMode: UISegmentedControl!
    
    private let gameboard = Gameboard()
    
    var playerInputMoves: [GameboardPosition] = []
    var markViewsPrototype: [MarkView] = []
    
    private var currentState: GameState! {
        didSet {
            self.currentState.begin()
        }
    }
    
    private lazy var referee = Referee(gameboard: self.gameboard)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.goToFirstState()
        
        gameboardView.onSelectPosition = { [weak self] position in
            guard let self = self else { return }
            if self.gameMode.selectedSegmentIndex == 0 {
                self.currentState.addMark(at: position)
                if self.currentState.isCompleted {
                    self.goToNextState()
                }
            } else {
                self.currentState.addMarks(at: position)
                if self.currentState.isCompleted {
                    self.goToNextState3()
                }
                //            self.gameboardView.placeMarkView(XView(), at: position)
            }
        }
    }
    
    private func goToFirstState() {
        let player = Player.first
        self.currentState = PlayerInputState(player: .first, markViewPrototype: player.markViewPrototype, gameViewController: self, gameboard: gameboard, gameboardView: gameboardView)
    }
    
    private func goToNextState() {
        if let winner = self.referee.determineWinner() {
            self.currentState = GameEndedState(winner: winner, gameViewController: self)
            return

        }
        if let playerInputState = currentState as? PlayerInputState {
            let player = playerInputState.player.next
            self.currentState = PlayerInputState(player: player, markViewPrototype: player.markViewPrototype, gameViewController: self, gameboard: gameboard, gameboardView: gameboardView)

        }
    }
        
    private func goToNextState3() {
        if let playerInputState = currentState as? PlayerInputState {
            guard playerInputState.player == .first else {
                self.currentState.showMarks(markViewsPrototype, at: playerInputMoves)
                self.currentState.showMarks(playerInputState.markViewsPrototype, at: playerInputState.playerInputMoves)
                if let winner = self.referee.determineWinner() {
                    self.currentState = GameEndedState(winner: winner, gameViewController: self)
                    return
                    
                }
                return
            }
            let player = playerInputState.player.next
            self.currentState = PlayerInputState(player: player, markViewPrototype: player.markViewPrototype, gameViewController: self, gameboard: gameboard, gameboardView: gameboardView)
            
            playerInputMoves += playerInputState.playerInputMoves
            markViewsPrototype += playerInputState.markViewsPrototype
        }
    }
    
    @IBAction func restartButtonTapped(_ sender: UIButton) {
        Log(.restartGame)
        
    }
}

