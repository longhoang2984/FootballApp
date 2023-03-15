//
//  MatchMapper.swift
//  
//
//  Created by Cửu Long Hoàng on 15/03/2023.
//

import Foundation

public final class MatchMapper {
    private struct Root: Decodable {
        private let matches: RemoteMatches
        
        private struct RemoteMatches: Decodable {
            let previous: [RemoteMatch]
            let upcoming: [RemoteMatch]
        }
        
        private struct RemoteMatch: Decodable {
            let date: Date
            let description: String
            let home: String
            let away: String
            let winner: String?
            let highlights: URL?
        }
        
        var matchList: [Match] {
            let p = matches.previous.map({
                Match(date: $0.date,
                              description: $0.description,
                              home: $0.home,
                              away: $0.away,
                              winner: $0.winner,
                              highlights: $0.highlights) })
            
            let u = matches.upcoming.map({
                Match(date: $0.date,
                              description: $0.description,
                              home: $0.home,
                              away: $0.away) })
            
            return p + u
        }
    }
    
    public enum Error: Swift.Error {
        case invalidData
    }
    
    public static func map(_ data: Data, from response: HTTPURLResponse) throws -> [Match] {
        let formatter = ISO8601DateFormatter()
        let decoder = JSONDecoder()
        formatter.formatOptions = [.withInternetDateTime,
                                   .withFractionalSeconds]
        decoder.dateDecodingStrategy = .custom({ decoder in
            let container = try decoder.singleValueContainer()
            let dateString = try container.decode(String.self)
            
            if let date = formatter.date(from: dateString) {
                return date
            }
            
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Cannot decode date string \(dateString)")
        })
        
        guard response.isOK, let root = try? decoder.decode(Root.self, from: data) else {
            throw Error.invalidData
        }
        
        return root.matchList
    }
}
