//
//  MatchCacheTestHelpers.swift
//  
//
//  Created by Cửu Long Hoàng on 15/03/2023.
//

import Foundation
import Football

func uniquePreviousMatch() -> Match {
    return Match(date: Date(timeIntervalSince1970: 1650736800),
                 description: "Team A vs Team B",
                 home: "Team A",
                 away: "Team B",
                 winner: "Team B",
                 highlights: anyURL())
}

func uniqueUpcomingMatch() -> Match {
    return Match(date: Date(timeIntervalSince1970: 1682272800),
                 description: "Team C vs Team D",
                 home: "Team C",
                 away: "Team D")
}

func uniqueMatches() -> (models: [Match], local: [LocalMatch]) {
    let models = [uniquePreviousMatch(), uniqueUpcomingMatch()]
    let local = models.map { LocalMatch(date: $0.date,
                                        description: $0.description,
                                        home: $0.home,
                                        away: $0.away,
                                        winner: $0.winner,
                                        highlights: $0.highlights) }
    return (models, local)
}
