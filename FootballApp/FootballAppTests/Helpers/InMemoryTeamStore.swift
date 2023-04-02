//
//  InMemoryTeamStore.swift
//  FootballAppTests
//
//  Created by Cửu Long Hoàng on 02/04/2023.
//

import Foundation
import Football

class InMemoryTeamStore {
    private(set) var teamCache: CachedTeam?
    private var teamImageDataCache: [URL: Data] = [:]
    
    private init(teamCache: CachedTeam? = nil) {
        self.teamCache = teamCache
    }
}

extension InMemoryTeamStore: TeamStore {
    func deleteCachedTeam() throws {
        teamCache = nil
    }

    func insert(_ teams: [LocalTeam]) throws {
        teamCache = CachedTeam(teams)
    }

    func retrieve() throws -> CachedTeam? {
        teamCache
    }
}

extension InMemoryTeamStore: TeamLogoDataStore {
    func insert(_ data: Data, for url: URL) throws {
        teamImageDataCache[url] = data
    }
    
    func retrieve(dataForURL url: URL) throws -> Data? {
        teamImageDataCache[url]
    }
}

extension InMemoryTeamStore {
    static var empty: InMemoryTeamStore {
        InMemoryTeamStore()
    }
    
    static var withTeamCache: InMemoryTeamStore {
        InMemoryTeamStore(teamCache: CachedTeam([]))
    }
}
