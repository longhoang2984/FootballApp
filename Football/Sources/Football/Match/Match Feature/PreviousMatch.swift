//
//  PreviousMatch.swift
//  
//
//  Created by Cửu Long Hoàng on 15/03/2023.
//

import Foundation

public struct PreviousMatch: Match {
    public let date: Date
    public let description: String
    public let home: String
    public let away: String
    public let winner: String
    public let highlights: URL
    
    public init(date: Date,
                description: String,
                home: String,
                away: String,
                winner: String,
                highlights: URL) {
        self.date = date
        self.description = description
        self.home = home
        self.away = away
        self.winner = winner
        self.highlights = highlights
    }
}
