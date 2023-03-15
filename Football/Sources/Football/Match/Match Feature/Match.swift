//
//  Match.swift
//  
//
//  Created by Cửu Long Hoàng on 15/03/2023.
//

import Foundation

public protocol Match {
    var date: Date { get }
    var description: String { get }
    var home: String { get }
    var away: String { get }
}
