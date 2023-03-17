//
//  NullStore.swift
//  FootballApp
//
//  Created by Cửu Long Hoàng on 16/03/2023.
//

import Foundation
import Football

class NullStore {}

extension NullStore: TeamStore {
    func deleteCachedTeam() throws {}
    
    func insert(_ teams: [LocalTeam]) throws {}
    
    func retrieve() throws -> CachedTeam? { .none }
}

extension NullStore: MatchStore {
    func deleteCachedMatch() throws {}
    
    func insert(_ matches: [LocalMatch]) throws {}
    
    func retrieve() throws -> CachedMatch? { .none }
}

extension NullStore: TeamLogoDataStore {
    func insert(_ data: Data, for url: URL) throws {}
    
    func retrieve(dataForURL url: URL) throws -> Data? { .none }
}
