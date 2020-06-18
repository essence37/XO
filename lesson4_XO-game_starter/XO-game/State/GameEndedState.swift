//
//  GameEndedState.swift
//  XO-game
//
//  Created by Alexander Bondarenko on 15.06.2020.
//  Copyright © 2020 plasmon. All rights reserved.
//

import Foundation

public class GameEndedState: GameState {
    
    public let isCompleted: Bool = false
    
    public let winner: Player?
    private(set) weak var gameViewController: GameViewController?
    private(set) weak var playerVsComputerViewController: PlayerVsComputerViewController?
    
    init(winner: Player?, gameViewController: GameViewController) {
        self.winner = winner
        self.gameViewController = gameViewController
    }
    
    init(winner: Player?, playerVsComputerViewController: PlayerVsComputerViewController) {
        self.winner = winner
        self.playerVsComputerViewController = playerVsComputerViewController
    }
    
    public func begin() {
        Log(.gameFinished(winner: self.winner))
        self.gameViewController?.winnerLabel.isHidden = false
        self.playerVsComputerViewController?.winnerLabel.isHidden = false
        
        if let winner = winner {
            self.gameViewController?.winnerLabel.text = self.winnerName(from: winner) + " win "
            self.playerVsComputerViewController?.winnerLabel.text = self.winnerName(from: winner)
        } else {
            self.gameViewController?.winnerLabel.text = "No winner"
            self.playerVsComputerViewController?.winnerLabel.text = "No winner"
        }
        
        self.gameViewController?.firstPlayerTurnLabel.isHidden = true
        self.gameViewController?.secondPlayerTurnLabel.isHidden = true
        self.playerVsComputerViewController?.firstPlayerTurnLabel.isHidden = true
        self.playerVsComputerViewController?.computerTurnLabel.isHidden = true
    }
    
    public func addMark(at position: GameboardPosition) {   }
    
    public func computerAddMark() -> GameboardPosition {
        let position = GameboardPosition(column: Int.random(in: 1...GameboardSize.columns),
                                         row: Int.random(in: 1...GameboardSize.rows))
        return position
    }
    
    private func winnerName(from winner: Player) -> String {
        switch winner {
        case .first: return "1st player"
        case .second: return "2st player"
        case .player: return "Victory"
        case .computer: return "Defeat"
        }
    }
}
