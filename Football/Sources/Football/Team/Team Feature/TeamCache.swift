//
//  File.swift
//  
//
//  Created by Cửu Long Hoàng on 14/03/2023.
//

import Foundation

public protocol TeamCache {
    func save(_ teams: [Team]) throws
}
