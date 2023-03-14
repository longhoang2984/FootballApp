//
//  File.swift
//  
//
//  Created by Cửu Long Hoàng on 14/03/2023.
//

import Foundation
import Football

func uniqueTeam() -> Team {
    return Team(id: UUID(), name: "any", logo: anyURL())
}

func uniqueTeams() -> (models: [Team], local: [LocalTeam]) {
    let models = [uniqueTeam(), uniqueTeam()]
    let local = models.map { LocalTeam(id: $0.id, name: $0.name, logo: $0.logo) }
    return (models, local)
}
