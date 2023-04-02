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
        let (sut, _, _) = makeSUT()
        
        sut.loadViewIfNeeded()
        
        XCTAssertEqual(sut.title, "Matches")
    }
    
    func test_teamSelection_notifiesHandler() {
        let teamA = uniqueTeam(teamName: "Team A")
        let teamB = uniqueTeam(teamName: "Team B")
        let previousMatch = uniquePreviousMatch(home: teamA.name, away: teamB.name)
        
        var selectedTeams = [TeamMessage]()
        let (sut, teamLoader, matchLoader) = makeSUT { selectedTeams.append(TeamMessage(team: $0, image: $1)) }
        
        sut.loadViewIfNeeded()
        teamLoader.completeTeamLoading(with: [teamA, teamB])
        matchLoader.completeMatchLoading(with: [previousMatch])
        
        sut.simulateTapOnHomeTeamName(at: 0, section: 0)
        XCTAssertEqual(selectedTeams, [TeamMessage(team: teamA, image: nil)])
        
        sut.simulateTapOnAwayTeamName(at: 0, section: 0)
        XCTAssertEqual(selectedTeams, [TeamMessage(team: teamA, image: nil),
                                       TeamMessage(team: teamB, image: nil)])
    }

    // MARK: - Helpers
    private func makeSUT(
        selection: @escaping (Team, UIImage?) -> Void = { _, _ in },
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> (sut: MainViewController, teamLoader: TeamLoaderSpy, matchLoader: MatchLoaderSpy) {
        let teamLoader = TeamLoaderSpy()
        let matchLoader = MatchLoaderSpy()
        let sut = MainUIComposer.mainComposedWith(teamLoader: teamLoader.loadPublisher,
                                                  matchLoader: matchLoader.loadPublisher,
                                                  imageLoader: teamLoader.loadTeamLogoPublisher,
                                                  awayImageLoader: teamLoader.loadTeamLogoPublisher,
                                                  selection: selection)
        trackForMemoryLeaks(teamLoader, file: file, line: line)
        trackForMemoryLeaks(matchLoader, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, teamLoader, matchLoader)
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
    ) -> (sut: TeamDetailViewController, teamLoader: TeamLoaderSpy, matchLoader: MatchLoaderSpy) {
        let teamLoader = TeamLoaderSpy()
        let matchLoader = MatchLoaderSpy()
        let sut = DetailUIComposer.detailComposedWith(team: uniqueTeam(teamName: "Team A"),
                                                      image: UIImage.make(withColor: .red),
                                                      teamLoader: teamLoader.loadPublisher,
                                                  matchLoader: matchLoader.loadPublisher,
                                                  imageLoader: teamLoader.loadTeamLogoPublisher,
                                                  awayImageLoader: teamLoader.loadTeamLogoPublisher)
        trackForMemoryLeaks(teamLoader, file: file, line: line)
        trackForMemoryLeaks(matchLoader, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, teamLoader, matchLoader)
    }

}
