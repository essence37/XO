//
//  PlayerVsComputerViewController.swift
//  XO-game
//
//  Created by Пазин Даниил on 16.06.2020.
//  Copyright © 2020 plasmon. All rights reserved.
//

import UIKit

class PlayerVsComputerViewController: UIViewController {

    @IBOutlet var gameboardView: GameboardView!
    @IBOutlet var firstPlayerTurnLabel: UILabel!
    @IBOutlet var computerTurnLabel: UILabel!
    @IBOutlet var winnerLabel: UILabel!
    @IBOutlet var restartButton: UILabel!
    
    private let gameboard = Gameboard()
    
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
            self.currentState.addMark(at: position)
            if self.currentState.isCompleted {
                self.goToNextState()
            }
//            self.gameboardView.placeMarkView(XView(), at: position)
        }
    }
    
    private func goToFirstState() {
        let player = Player.player
        self.currentState = PlayerInputState(player: player, markViewPrototype: player.markViewPrototype, playerVsComputerViewController: self, gameboard: gameboard, gameboardView: gameboardView)
    }
    
    private func goToNextState() {
        if let winner = self.referee.determineWinner() {
            self.currentState = GameEndedState(winner: winner, playerVsComputerViewController: self)
            return
            
        }
        if let playerInputState = currentState as? PlayerInputState {
            let player = playerInputState.player.next
            self.currentState = PlayerInputState(player: player, markViewPrototype: player.markViewPrototype, playerVsComputerViewController: self, gameboard: gameboard, gameboardView: gameboardView)
            if player == .computer {
                var position = currentState.computerAddMark()
                while gameboardView.canPlaceMarkView(at: position) != true {
                    position = currentState.computerAddMark()
                }
                self.currentState.addMark(at: position)
                if self.currentState.isCompleted {
                    self.goToNextState()
                }
            }
        }
    }
    
    @IBAction func restartButtonTapped(_ sender: UIButton) {
        Log(.restartGame)
        
    }
}
