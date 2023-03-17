//
//  DisplayModel.swift
//  
//
//  Created by Cửu Long Hoàng on 15/03/2023.
//

import Foundation

public struct DisplayModel {
    public let date: String
    public let time: String
    public let description: String
    public let home: String
    public let away: String
    public let winner: String?
    public let highlights: URL?
    public let homeLogo: URL?
    public let awayLogo: URL?
    
    public init(date: String,
                time: String,
                description: String,
                home: String,
                away: String,
                homeLogo: URL? = nil,
                awayLogo: URL? = nil,
                winner: String? = nil,
                highlights: URL? = nil) {
        self.date = date
        self.time = time
        self.description = description
        self.home = home
        self.away = away
        self.homeLogo = homeLogo
        self.awayLogo = awayLogo
        self.winner = winner
        self.highlights = highlights
    }
}
