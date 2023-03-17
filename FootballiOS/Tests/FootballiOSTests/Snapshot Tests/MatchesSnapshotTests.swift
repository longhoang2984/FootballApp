//
//  MatchesSnapshotTests.swift
//  
//
//  Created by Cửu Long Hoàng on 17/03/2023.
//

import XCTest
import Football
@testable import FootballiOS

final class MatchesSnapshotTests: XCTestCase {

    func test_emptyList() {
        let (sut, _) = makeSUT()
        sut.display([])

        assert(snapshot: sut.snapshot(for: .iPhone13(style: .light)), named: "EMPTY_LIST_light")
        assert(snapshot: sut.snapshot(for: .iPhone13(style: .dark)), named: "EMPTY_LIST_dark")
    }
    
    func test_matchList_withEmptyImage() {
        let (sut, _) = makeSUT()
        
        sut.display(controllers())
        
        assert(snapshot: sut.snapshot(for: .iPhone13(style: .light)), named: "CONTROLLER_LIST_light")
        assert(snapshot: sut.snapshot(for: .iPhone13(style: .dark)), named: "CONTROLLER_LIST_dark")
    }
    
    func test_matchList_withImages() {
        let (sut, _) = makeSUT()
        
        sut.display(controllers(homeImage: UIImage.make(withColor: .green),
                                awayImage: UIImage.make(withColor: .blue)))
        
        assert(snapshot: sut.snapshot(for: .iPhone13(style: .light)), named: "CONTROLLER_LIST_WITH_IMAGES_light")
        assert(snapshot: sut.snapshot(for: .iPhone13(style: .dark)), named: "CONTROLLER_LIST_WITH_IMAGES_dark")
    }
    
    // MARK: - Helpers
    
    private func makeSUT() -> (sut: MainViewController, spy: ViewModelSpy) {
        let spy = ViewModelSpy()
        let sut = MainViewController(viewModel: spy)
        sut.loadViewIfNeeded()
        return (sut, spy)
    }
    
    private class ViewModelSpy: AppViewModel {}
    
    private class Stub: MatchCellControllerDelegate {
        private let vm: TeamLogoViewModel<UIImage>
        private let img: UIImage?
        
        init(vm: TeamLogoViewModel<UIImage>,
             img: UIImage? = nil) {
            self.vm = vm
            self.img = img
        }
        
        func didRequestImage(url: URL) {
            if let img = img {
                vm.input.send(.showImageData(img.pngData()!))
            }
        }
        
        func didCancelImageRequest() {}
    }
    
    private func controllers(homeImage: UIImage? = nil, awayImage: UIImage? = nil) -> [CellController] {
        let teams = [
            uniqueTeam(teamName: "Team A"),
            uniqueTeam(teamName: "Team B"),
            uniqueTeam(teamName: "Team C"),
            uniqueTeam(teamName: "Team D"),
        ]
        
        let matches = [
            uniquePreviousMatch(),
            uniqueUpcomingMatch(),
        ]
        
        return matches.map { match in
            let home = teams.first(where: { $0.name == match.home })!
            let away = teams.first(where: { $0.name == match.away })!
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM"
            let date = dateFormatter.string(from: match.date)
            
            dateFormatter.dateFormat = "HH:mm"
            let time = dateFormatter.string(from: match.date)
            let displayModel = DisplayModel(date: date, time: time,
                                            description: match.description, home: match.home,
                                            away: match.away, homeLogo: home.logo, awayLogo: away.logo,
                                            winner: match.winner, highlights: match.highlights)
            
            let homeVM = TeamLogoViewModel<UIImage>(mapper: UIImage.tryMake)
            let awayVM = TeamLogoViewModel<UIImage>(mapper: UIImage.tryMake)
            let cellController = MatchCellController(model: displayModel,
                                                     homeDelegate: Stub(vm: homeVM,
                                                                        img: homeImage),
                                                     awayDelegate: Stub(vm: awayVM,
                                                                       img: awayImage),
                                                     selection: { _, _ in },
                                                     onShowHighlight: { })
            cellController.homeImageViewModel = homeVM
            cellController.awayImageViewModel = awayVM
            
            return CellController(id: UUID(), cellController)
        }
    }
    
    private func uniquePreviousMatch() -> Match {
        return Match(date: Date(timeIntervalSince1970: 1650736800),
                     description: "Team A vs Team B",
                     home: "Team A",
                     away: "Team B",
                     winner: "Team B",
                     highlights: anyURL())
    }

    private func uniqueUpcomingMatch() -> Match {
        return Match(date: Date(timeIntervalSince1970: 1682272800),
                     description: "Team C vs Team D",
                     home: "Team C",
                     away: "Team D")
    }
    
    private func anyURL() -> URL {
        return URL(string: "http://any-url.com")!
    }
    
    private func uniqueTeam(teamName: String) -> Team {
        return Team(id: UUID(), name: teamName, logo: anyURL())
    }

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
