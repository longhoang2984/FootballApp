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
                                                  awayImageLoader: teamLoader.loadTeamLogoPublisher)
        trackForMemoryLeaks(teamLoader, file: file, line: line)
        trackForMemoryLeaks(matchLoader, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, teamLoader, matchLoader)
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
