//
//  InMemoryMatchStore.swift
//  FootballAppTests
//
//  Created by Cửu Long Hoàng on 02/04/2023.
//

import Foundation
import Football

class InMemoryMatchStore {
    private(set) var matchCache: CachedMatch?
    
    private init(matchCache: CachedMatch? = nil) {
        self.matchCache = matchCache
    }
}

extension InMemoryMatchStore: MatchStore {
    func deleteCachedMatch() throws {
        matchCache = nil
    }
    
    func insert(_ matches: [LocalMatch]) throws {
        matchCache = CachedMatch(matches)
    }
    
    func retrieve() throws -> CachedMatch? {
        matchCache
    }
}

extension InMemoryMatchStore {
    static var empty: InMemoryMatchStore {
        InMemoryMatchStore()
    }
    
    static var withTeamCache: InMemoryMatchStore {
        InMemoryMatchStore(matchCache: CachedMatch([]))
    }
}
