//
//  TeamViewModel.swift
//  
//
//  Created by Cửu Long Hoàng on 15/03/2023.
//

import Foundation
import Combine

public final class TeamViewModel {
    public enum Input {
        case getTeams
    }
    
    public enum Output {
        case getTeamsDidFail(error: Error)
        case getTeams(teams: [Team])
    }
}
