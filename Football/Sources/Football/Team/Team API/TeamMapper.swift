//
//  TeamMapper.swift
//  
//
//  Created by Cửu Long Hoàng on 14/03/2023.
//

import Foundation

public final class TeamMapper {
    private struct Root: Decodable {
        private let teams: [RemoteTeam]
        
        private struct RemoteTeam: Decodable {
            let id: UUID
            let name: String
            let logo: URL
        }
        
        var teamList: [Team] {
            teams.map { Team(id: $0.id, name: $0.name, logo: $0.logo) }
        }
    }
    
    public enum Error: Swift.Error {
        case invalidData
    }
    
    public static func map(_ data: Data, from response: HTTPURLResponse) throws -> [Team] {
        guard response.isOK, let root = try? JSONDecoder().decode(Root.self, from: data) else {
            throw Error.invalidData
        }
        
        return root.teamList
    }
}
