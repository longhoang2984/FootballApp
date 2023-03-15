//
//  File.swift
//  
//
//  Created by Cửu Long Hoàng on 15/03/2023.
//

import Foundation

extension CoreDataTeamStore: MatchStore {
    public func deleteCachedMatch() throws {
        try performSync { context in
            Result {
                try ManagedMatchCache.deleteCache(in: context)
            }
        }
    }
    
    public func insert(_ matches: [LocalMatch]) throws {
        try performSync { context in
            Result {
                let managedCache = try ManagedMatchCache.newUniqueInstance(in: context)
                managedCache.matches = ManagedMatch.images(from: matches, in: context)
                try context.save()
            }
        }
    }
    
    public func retrieve() throws -> CachedMatch? {
        try performSync { context in
            Result {
                try ManagedMatchCache.find(in: context).map {
                    CachedMatch($0.localMatch)
                }
            }
        }
    }
    
    
}
