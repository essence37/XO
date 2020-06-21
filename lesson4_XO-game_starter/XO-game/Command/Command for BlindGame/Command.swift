//
//  Command.swift
//  XO-game
//
//  Created by Пазин Даниил on 21.06.2020.
//  Copyright © 2020 plasmon. All rights reserved.
//

import UIKit

final class Command {
    
    let position: GameboardPosition
    let player: Player
    let gameboard: Gameboard
    let gameboardView: GameboardView
    
    init(position: GameboardPosition, player: Player, gameboard: Gameboard, gameboardView: GameboardView) {
        self.position = position
        self.player = player
        self.gameboard = gameboard
        self.gameboardView = gameboardView
    }
    
    func execute() {
        let markView = self.player.markViewPrototype
        self.gameboard.clearPlayer(at: position)
        self.gameboardView.removeMarkView(at: position)
        self.gameboard.setPlayer(player, at: position)
        self.gameboardView.placeMarkView(markView, at: position)
    }
}
