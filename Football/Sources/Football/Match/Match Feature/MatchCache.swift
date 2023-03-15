//
//  File.swift
//  
//
//  Created by Cửu Long Hoàng on 15/03/2023.
//

import Foundation

public protocol MatchCache {
    func save(_ matches: [Match]) throws
}
