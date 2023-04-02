//
//  SharedTestHelpers.swift
//  FootballAppTests
//
//  Created by Cửu Long Hoàng on 02/04/2023.
//

import Foundation
import Football

func anyNSError() -> NSError {
    return NSError(domain: "any error", code: 0)
}

func anyURL() -> URL {
    return URL(string: "http://any-url.com")!
}

func anyData() -> Data {
    return Data("any data".utf8)
}

func uniquePreviousMatch(home: String, away: String) -> Match {
    return Match(date: Date(timeIntervalSince1970: 1650736800),
                 description: "any desc",
                 home: home,
                 away: away,
                 winner: away,
                 highlights: anyURL(team: "highlight"))
}

func uniqueUpcomingMatch(home: String, away: String) -> Match {
    return Match(date: Date(timeIntervalSince1970: 1682272800),
                 description: "Team C vs Team D",
                 home: home,
                 away: away)
}

func anyURL(team: String) -> URL {
    return URL(string: "http://any-\(team.split(separator: " ").joined())-url.com")!
}

func uniqueTeam(teamName: String) -> Team {
    return Team(id: UUID(), name: teamName, logo: anyURL(team: teamName))
}

private class DummyView: TeamLogoView {
    typealias Img = Any
    
    func display(_ model: TeamLogoModel<Img>) {}
}
