//
//  XCTestCase+ShareHelpers.swift
//  
//
//  Created by Cửu Long Hoàng on 02/04/2023.
//

import Foundation
import Football
import Combine
import UIKit
@testable import FootballiOS

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

extension UIImage {
    struct InvalidImageData: Error {}

    static func tryMake(data: Data) throws -> UIImage {
        guard let image = UIImage(data: data) else {
            throw InvalidImageData()
        }

        return image
    }
}

class Stub: MatchCellControllerDelegate {
    let homeLogo: UIImage?
    let awayLogo: UIImage?
    let home: Team
    let away: Team
    let match: Match
    let isPrevious: Bool
    weak var controller: MatchCellController?
    
    init(homeLogo: UIImage?,
         awayLogo: UIImage?,
         home: Team,
         away: Team,
         isPrevious: Bool = false) {
        self.homeLogo = homeLogo
        self.awayLogo = awayLogo
        self.home = home
        self.away = away
        self.isPrevious = isPrevious
        if isPrevious {
            self.match = uniquePreviousMatch(home: home.name, away: away.name)
        } else {
            self.match = uniqueUpcomingMatch(home: home.name, away: away.name)
        }
    }
    
    func didRequestImage(url: URL) {
        let homeVM = TeamLogoModel(image: homeLogo,
                                   isLoading: homeLogo == nil,
                                   url: anyURL(team: home.name))
        controller?.display(homeVM)
        
        let awayVM = TeamLogoModel(image: awayLogo,
                                   isLoading: awayLogo == nil,
                                   url: anyURL(team: away.name))
        controller?.display(awayVM)
    }
    
    func didCancelImageRequest() {}
}

func controllers(stubs: [Stub]) -> [[CellController]] {
    var previous = [CellController]()
    var upcoming = [CellController]()
    stubs.forEach {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM-HH:mm"
        let component = dateFormatter.string(from: $0.match.date).split(separator: "-")
        
        let date = String(component.first ?? "")
        let time = String(component.last ?? "")
        let displayModel = DisplayModel(date: date, time: time,
                                        description: $0.match.description, home: $0.match.home,
                                        away: $0.match.away, homeLogo: $0.home.logo, awayLogo: $0.away.logo,
                                        winner: $0.match.winner, highlights: $0.match.highlights)
        
        let cellController = MatchCellController(model: displayModel,
                                                 homeDelegate: $0,
                                                 awayDelegate: $0,
                                                 selection: { _, _ in },
                                                 onShowHighlight: { })
        $0.controller = cellController
        
        let cell = CellController(id: UUID(), cellController)
        if $0.match.winner == nil {
            upcoming.append(cell)
        } else {
            previous.append(cell)
        }
    }
    
    return [previous, upcoming]
}
