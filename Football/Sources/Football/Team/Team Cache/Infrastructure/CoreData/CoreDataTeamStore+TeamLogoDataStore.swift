//
//  File.swift
//  
//
//  Created by Cửu Long Hoàng on 14/03/2023.
//

import Foundation

extension CoreDataTeamStore: TeamLogoDataStore {
    public func insert(_ data: Data, for url: URL) throws {
        try performSync { context in
            Result {
                try ManagedTeam.first(with: url, in: context)
                    .map { $0.data = data }
                    .map(context.save)
            }
        }
    }
    
    public func retrieve(dataForURL url: URL) throws -> Data? {
        try performSync { context in
            Result {
                try ManagedTeam.data(with: url, in: context)
            }
        }
    }
    
}
