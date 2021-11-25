//
//  Team.swift
//  NBAPlayers
//
//

import Foundation

struct Team: Decodable, Equatable, Hashable {
    var abbreviation: String
}

extension Team: ExpressibleByStringLiteral {
    init(stringLiteral value: StringLiteralType) {
        self = Team(abbreviation: value)
    }
}
