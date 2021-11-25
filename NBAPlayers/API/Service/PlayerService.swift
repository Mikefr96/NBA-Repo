//
//  PlayerServiceProtocol.swift
//  NBAPlayers
//
//  Created by Mike R on 25/11/2021.
//

import Foundation
import Combine

enum ServiceError: Error {
    case url(URLError)
    case urlRequest
    case decode
}

protocol PlayersServiceProtocol {
    func get(searchTerm: String?) -> AnyPublisher<[Player], Error>
}

let apiKey: String = "eaceee896amsh7767b6cae6fce67p1a36a2jsn5f195dbbc295" // use your rapidapi

final class PlayersService: PlayersServiceProtocol {
    
    func get(searchTerm: String?) -> AnyPublisher<[Player], Error> {
        var dataTask: URLSessionDataTask?
        
        let onSubscription: (Subscription) -> Void = { _ in dataTask?.resume() }
        let onCancel: () -> Void = { dataTask?.cancel()
        }
        
        // promise type is Result<[Player], Error>
        return Future<[Player], Error> { [weak self] promise in
            guard let urlRequest = self?.getUrlRequest(searchTerm: searchTerm) else {
                promise(.failure(ServiceError.urlRequest))
                return
            }
            
            dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, _, error) in
                guard let data = data else {
                    if let error = error {
                        promise(.failure(error))
                    }
                    return
                }
                do {
                    let players = try JSONDecoder().decode(PlayerData.self, from: data)
                    promise(.success(players.data))
                } catch {
                    promise(.failure(ServiceError.decode))
                }
            }
        }
        .handleEvents(receiveSubscription: onSubscription, receiveCancel: onCancel)
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
    
    private func getUrlRequest(searchTerm: String?) -> URLRequest? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "free-nba.p.rapidapi.com"
        components.path = "/players"
        if let searchTerm = searchTerm, !searchTerm.isEmpty {
            components.queryItems = [
                URLQueryItem(name: "search", value: searchTerm)
            ]
        }
        
        guard let url = components.url else { return nil }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.timeoutInterval = 10.0
        urlRequest.httpMethod = "GET"
        urlRequest.allHTTPHeaderFields = [
            "X-RapidAPI-Host": "free-nba.p.rapidapi.com",
            "X-RapidAPI-Key": apiKey
        ]
        return urlRequest
    }
}
