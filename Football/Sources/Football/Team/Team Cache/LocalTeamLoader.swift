//
//  LocalTeamLoader.swift
//  
//
//  Created by Cửu Long Hoàng on 14/03/2023.
//

import Foundation

public final class LocalTeamLoader {
    private let store: TeamStore
    
    public init(store: TeamStore) {
        self.store = store
    }
}

extension LocalTeamLoader: TeamCache {
    public func save(_ teams: [Team]) throws {
        try store.deleteCachedTeam()
        try store.insert(teams.toLocal())
    }
}

extension LocalTeamLoader {
    public func load() throws -> [Team] {
        if let cache = try store.retrieve() {
            return cache.toModels()
        }
        return []
    }
}

private extension Array where Element == Team {
    func toLocal() -> [LocalTeam] {
        return map { LocalTeam(id: $0.id, name: $0.name,  logo: $0.logo) }
    }
}

private extension Array where Element == LocalTeam {
    func toModels() -> [Team] {
        return map { Team(id: $0.id, name: $0.name,  logo: $0.logo) }
    }
}
