//
//  File.swift
//  
//
//  Created by Cửu Long Hoàng on 14/03/2023.
//

import Foundation

extension CoreDataTeamStore: TeamStore {
    public func deleteCachedTeam() throws {
        try performSync { context in
            Result {
                try ManagedTeamCache.deleteCache(in: context)
            }
        }
    }
    
    public func insert(_ teams: [LocalTeam]) throws {
        try performSync { context in
            Result {
                let managedCache = try ManagedTeamCache.newUniqueInstance(in: context)
                managedCache.teams = ManagedTeam.images(from: teams, in: context)
                try context.save()
            }
        }
    }
    
    public func retrieve() throws -> CachedTeam? {
        try performSync { context in
            Result {
                try ManagedTeamCache.find(in: context).map {
                    CachedTeam($0.localTeam)
                }
            }
        }
    }
    
}
