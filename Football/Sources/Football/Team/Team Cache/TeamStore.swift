//
//  TeamStore.swift
//  
//
//  Created by Cửu Long Hoàng on 14/03/2023.
//

import Foundation

public protocol TeamStore {
    func deleteCachedTeam() throws
    func insert(_ feed: [LocalTeam]) throws
    func retrieve() throws -> [LocalTeam]?
}
