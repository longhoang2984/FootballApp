//
//  MainUIIntegrationTests.swift
//  FootballAppTests
//
//  Created by Cửu Long Hoàng on 02/04/2023.
//

import XCTest
import Football
import FootballiOS
@testable import FootballApp

final class MainUIIntegrationTests: XCTestCase {
    func test_feedView_hasTitle() {
        let (sut, _) = makeSUT()
        
        sut.loadViewIfNeeded()
        
        XCTAssertEqual(sut.title, "Matches")
    }
    
    func test_teamSelection_notifiesHandler() {
        let teamA = uniqueTeam(teamName: "Team A")
        let teamB = uniqueTeam(teamName: "Team B")
        let previousMatch = uniquePreviousMatch(home: teamA.name, away: teamB.name)
        
        var selectedTeams = [TeamMessage]()
        let (sut, loader) = makeSUT { selectedTeams.append(TeamMessage(team: $0, image: $1)) }
        
        sut.loadViewIfNeeded()
        loader.completeTeamLoading(with: [teamA, teamB])
        loader.completeMatchLoading(with: [previousMatch])
        
        sut.simulateTapOnHomeTeamName(at: 0, section: 0)
        XCTAssertEqual(selectedTeams, [TeamMessage(team: teamA, image: nil)])
        
        sut.simulateTapOnAwayTeamName(at: 0, section: 0)
        XCTAssertEqual(selectedTeams, [TeamMessage(team: teamA, image: nil),
                                       TeamMessage(team: teamB, image: nil)])
    }
    
    func test_loadMatchActions_requestTeamsAndMatchesFromLoader() {
        let (sut, loader) = makeSUT()
        XCTAssertEqual(loader.loadTeamCallCount, 0, "Expected no loading requests before view is loaded")
        XCTAssertEqual(loader.loadMatchCallCount, 0, "Expected no loading requests before view is loaded")
        
        sut.loadViewIfNeeded()
        XCTAssertEqual(loader.loadTeamCallCount, 1, "Expected a loading request once view is loaded")
        loader.completeTeamLoading(with: [])
        XCTAssertEqual(loader.loadMatchCallCount, 1, "Expected a loading request once view is loaded")
    }

    // MARK: - Helpers
    private func makeSUT(
        selection: @escaping (Team, UIImage?) -> Void = { _, _ in },
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> (sut: MainViewController, loader: LoaderSpy) {
        let loader = LoaderSpy()
        let sut = MainUIComposer.mainComposedWith(teamLoader: loader.loadPublisher,
                                                  matchLoader: loader.loadMatchPublisher,
                                                  imageLoader: loader.loadTeamLogoPublisher,
                                                  awayImageLoader: loader.loadTeamLogoPublisher,
                                                  selection: selection)
        trackForMemoryLeaks(loader, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, loader)
    }
    
    private struct TeamMessage: Equatable {
        private let team: Team
        private let image: UIImage?
        
        init(team: Team, image: UIImage?) {
            self.team = team
            self.image = image
        }
    }
    
    private func makeDetailSUT(
        selection: @escaping (Team, UIImage?) -> Void = { _, _ in },
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> (sut: TeamDetailViewController, loader: LoaderSpy) {
        let loader = LoaderSpy()
        let sut = DetailUIComposer.detailComposedWith(team: uniqueTeam(teamName: "Team A"),
                                                      image: UIImage.make(withColor: .red),
                                                      teamLoader: loader.loadPublisher,
                                                  matchLoader: loader.loadMatchPublisher,
                                                  imageLoader: loader.loadTeamLogoPublisher,
                                                  awayImageLoader: loader.loadTeamLogoPublisher)
        trackForMemoryLeaks(loader, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, loader)
    }

}
