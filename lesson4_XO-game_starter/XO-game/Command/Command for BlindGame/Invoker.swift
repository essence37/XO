//
//  Receiver.swift
//  XO-game
//
//  Created by Пазин Даниил on 21.06.2020.
//  Copyright © 2020 plasmon. All rights reserved.
//

import UIKit

internal final class Invoker {
    
    // MARK: Singleton
    
    internal static let shared = Invoker()
    
    // MARK: Private properties
    
    private let logger = Logger()
    
    private let batchSize = GameboardSize.columns*GameboardSize.rows+1
    
    private var commands: [Command] = []
    
    // MARK: Internal
    
    internal func addCommand(_ command: Command) {
        self.commands.append(command)
        self.executeCommandsIfNeeded()
    }
    
    // MARK: Private
    
    private func executeCommandsIfNeeded() {
        guard self.commands.count >= batchSize else {
            return
        }
        self.commands.forEach { $0.execute() }
        self.commands = []
    }
}
