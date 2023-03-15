//
//  File.swift
//  
//
//  Created by Cửu Long Hoàng on 15/03/2023.
//

import Foundation

public final class LocalMatchLoader {
    private let store: MatchStore
    
    public init(store: MatchStore) {
        self.store = store
    }
}

extension LocalMatchLoader: MatchCache {
    public func save(_ matches: [Match]) throws {
        try store.deleteCachedMatch()
        try store.insert(matches.toLocal())
    }
}

extension LocalMatchLoader {
    public func load() throws -> [Match] {
        if let cache = try store.retrieve() {
            return cache.toModels()
        }
        return []
    }
}

private extension Array where Element == Match {
    func toLocal() -> [LocalMatch] {
        return map { LocalMatch(date: $0.date,
                                description: $0.description,
                                home: $0.home,
                                away: $0.away,
                                winner: $0.winner,
                                highlights: $0.highlights) }
    }
}

private extension Array where Element == LocalMatch {
    func toModels() -> [Match] {
        return map { Match(date: $0.date,
                           description: $0.description,
                           home: $0.home,
                           away: $0.away,
                           winner: $0.winner,
                           highlights: $0.highlights) }
    }
}
