//
//  TeamStore.swift
//  
//
//  Created by Cửu Long Hoàng on 14/03/2023.
//

import Foundation

public typealias CachedTeam = ([LocalTeam])

public protocol TeamStore {
    func deleteCachedTeam() throws
    func insert(_ teams: [LocalTeam]) throws
    func retrieve() throws -> CachedTeam?
}
