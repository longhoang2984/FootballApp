//
//  LocalTeam.swift
//  
//
//  Created by Cửu Long Hoàng on 14/03/2023.
//

import Foundation

public struct LocalTeam: Equatable {
    public let id: UUID
    public let name: String
    public let logo: URL
    
    public init(id: UUID, name: String, logo: URL) {
        self.id = id
        self.name = name
        self.logo = logo
    }
}
