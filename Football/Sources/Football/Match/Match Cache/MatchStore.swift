//
//  MatchStore.swift
//  
//
//  Created by Cửu Long Hoàng on 15/03/2023.
//

import Foundation

public typealias CachedMatch = ([LocalMatch])

public protocol MatchStore {
    func deleteCachedMatch() throws
    func insert(_ matches: [LocalMatch]) throws
    func retrieve() throws -> CachedMatch?
}
