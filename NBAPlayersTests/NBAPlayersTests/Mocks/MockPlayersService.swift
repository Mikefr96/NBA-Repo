//
//  MockPlayersService.swift
//  
//
//

import Foundation
import Combine
@testable import NBAPlayers

final class MockPlayersService: PlayersServiceProtocol {
    var getArguments: [String?] = []
    var getCallsCount: Int = 0

    var getResult: Result<[Player], Error> = .success([])

    func get(searchTerm: String?) -> AnyPublisher<[Player], Error> {
        getArguments.append(searchTerm)
        getCallsCount += 1

        return getResult.publisher.eraseToAnyPublisher()
    }
}
