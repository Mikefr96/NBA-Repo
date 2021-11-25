//
//  PlayerCellViewModel.swift
//  NBAPlayers
//
//

import Foundation
import Combine

final class PlayerCellViewModel {
    @Published var playerName: String = ""
    @Published var team: String = ""
        
    private let player: Player
    
    init(player: Player) {
        self.player = player
        
        setUpBindings()
    }
    
    private func setUpBindings() {
        playerName = [player.firstName, player.lastName].joined(separator: " ")
        team = player.team.abbreviation
    }
}
