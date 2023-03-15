//
//  UpcomingMatch.swift
//  
//
//  Created by Cửu Long Hoàng on 15/03/2023.
//

import Foundation

public struct UpcomingMatch: Match {
    public let date: Date
    public let description: String
    public let home: String
    public let away: String
    
    public init(date: Date,
                description: String,
                home: String,
                away: String) {
        self.date = date
        self.description = description
        self.home = home
        self.away = away
    }
}
