//
//  MatchMapperTests.swift
//  
//
//  Created by Cửu Long Hoàng on 15/03/2023.
//

import XCTest
import Football

final class MatchMapperTests: XCTestCase {
    
    func test_map_throwsErrorOnNon200HTTPResponse() throws {
        let json = makeMatchesJSON(previousMatches: [], upcomingMatches: [])
        let samples = [199, 201, 300, 400, 500]
        
        try samples.forEach { code in
            XCTAssertThrowsError(
                try MatchMapper.map(json, from: HTTPURLResponse(statusCode: code))
            )
        }
    }
    
    func test_map_throwsErrorOn200HTTPResponseWithInvalidJSON() {
        let invalidJSON = Data("invalid json".utf8)
        
        XCTAssertThrowsError(
            try MatchMapper.map(invalidJSON, from: HTTPURLResponse(statusCode: 200))
        )
    }
    
    func test_map_deliversNoTeamsOn200HTTPResponseWithEmptyJSONList() throws {
        let emptyListJSON = makeMatchesJSON(previousMatches: [], upcomingMatches: [])
        
        let result = try MatchMapper.map(emptyListJSON, from: HTTPURLResponse(statusCode: 200))
        
        XCTAssertEqual(result, [])
    }
    
    func test_map_deliversTeamsOn200HTTPResponseWithJSONItems() throws {
        let previousMatch = makeMatch(
            date: (Date(timeIntervalSince1970: 1650736800), "2022-04-23T18:00:00.000Z"),
            description: "Team A vs Team B",
            home: "Team A",
            away: "Team B",
            winner: "Team B",
            highlights: anyURL())
        
        let upcomingMatch = makeMatch(
            date: (Date(timeIntervalSince1970: 1682272800), "2023-04-23T18:00:00.000Z"),
            description: "Team C vs Team D",
            home: "Team C",
            away: "Team D")
        
        let json = makeMatchesJSON(previousMatches: previousMatch.jsons, upcomingMatches: upcomingMatch.jsons)
        
        let result = try MatchMapper.map(json, from: HTTPURLResponse(statusCode: 200))
        
        XCTAssertEqual(result, [previousMatch.model, upcomingMatch.model])
    }
    
    // MARK: - Helpers
    
    private func makeMatch(date: (date: Date, iso8601String: String),
                           description: String,
                           home: String,
                           away: String,
                           winner: String? = nil,
                           highlights: URL? = nil) -> (model: Match, jsons: [[String: Any]]) {
        let item = Match(date: date.date,
                         description: description,
                         home: home,
                         away: away,
                         winner: winner,
                         highlights: highlights)
        
        let json = [[
            "date": date.iso8601String,
            "description": description,
            "home": home,
            "away": away,
            "winner": winner,
            "highlights": highlights?.absoluteString
        ].compactMapValues { $0 }]
        
        return (item, json)
    }
    
}
