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
    func test_mainView_hasTitle() {
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
    
    func test_loadMatchCompletion_rendersSuccessfullyLoaded() {
        let teamA = uniqueTeam(teamName: "Team A")
        let teamB = uniqueTeam(teamName: "Team B")
        let previousMatch = uniquePreviousMatch(home: teamA.name, away: teamB.name)
        let (sut, loader) = makeSUT()
        
        sut.loadViewIfNeeded()
        loader.completeTeamLoading(with: [teamA, teamB])
        loader.completeMatchLoading(with: [previousMatch])
        assertThat(sut, isRendering: [previousMatch])
    }
    
    func test_loadMatchCompletion_doesNotCallMatchLoaderWhenTeamLoaderFailure() {
        let (sut, loader) = makeSUT()
        XCTAssertEqual(loader.loadTeamCallCount, 0, "Expected no loading requests before view is loaded")
        XCTAssertEqual(loader.loadMatchCallCount, 0, "Expected no loading requests before view is loaded")
        
        sut.loadViewIfNeeded()
        loader.completeTeamLoadingWithError()
        
        XCTAssertEqual(loader.loadTeamCallCount, 1, "Expected no loading requests before view is loaded")
        XCTAssertEqual(loader.loadMatchCallCount, 0, "Expected no loading requests before view is loaded")
    }
    
    func test_loadMatchCompletion_matchLoaderFailure() {
        let (sut, loader) = makeSUT()
        XCTAssertEqual(loader.loadTeamCallCount, 0, "Expected no loading requests before view is loaded")
        XCTAssertEqual(loader.loadMatchCallCount, 0, "Expected no loading requests before view is loaded")
        
        sut.loadViewIfNeeded()
        let teamA = uniqueTeam(teamName: "Team A")
        let teamB = uniqueTeam(teamName: "Team B")
        
        loader.completeTeamLoading(with: [teamA, teamB])
        loader.completeMatchLoadingWithError()
        
        XCTAssertEqual(loader.loadTeamCallCount, 1, "Expected no loading requests before view is loaded")
        XCTAssertEqual(loader.loadMatchCallCount, 1, "Expected no loading requests before view is loaded")
    }
    
    func test_matchView_loadsImageURLWhenVisible() {
        let teamA = uniqueTeam(teamName: "Team A")
        let teamB = uniqueTeam(teamName: "Team B")
        let previousMatch = uniquePreviousMatch(home: teamA.name, away: teamB.name)
        let (sut, loader) = makeSUT()
        
        sut.loadViewIfNeeded()
        loader.completeTeamLoading(with: [teamA, teamB])
        loader.completeMatchLoading(with: [previousMatch])
        
        XCTAssertEqual(loader.loadedImageURLs, [], "Expected no image URL requests until views become visible")
        
        sut.simulateMatchViewVisible(at: 0, section: 0)
        XCTAssertEqual(loader.loadedImageURLs, [teamA.logo, teamB.logo], "Expected first image URL request once first view becomes visible")
        
        sut.simulateMatchViewVisible(at: 0, section: 1)
        XCTAssertEqual(loader.loadedImageURLs, [teamA.logo, teamB.logo], "Expected second image URL request once second view also becomes visible")
    }
    
    func test_matchView_cancelsImageLoadingWhenNotVisibleAnymore() {
        let teamA = uniqueTeam(teamName: "Team A")
        let teamB = uniqueTeam(teamName: "Team B")
        let previousMatch = uniquePreviousMatch(home: teamA.name, away: teamB.name)
        let (sut, loader) = makeSUT()
        
        sut.loadViewIfNeeded()
        loader.completeTeamLoading(with: [teamA, teamB])
        loader.completeMatchLoading(with: [previousMatch])
        XCTAssertEqual(loader.cancelledImageURLs, [], "Expected no cancelled image URL requests until image is not visible")
        
        sut.simulateMatchViewNotVisible(at: 0, section: 0)
        XCTAssertEqual(loader.cancelledImageURLs, [teamA.logo, teamB.logo], "Expected one cancelled image URL request once first image is not visible anymore")
        
        sut.simulateMatchViewVisible(at: 0, section: 0)
        XCTAssertEqual(loader.cancelledImageURLs, [teamA.logo, teamB.logo], "Expected two cancelled image URL requests once second image is also not visible anymore")
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

    func assertThat(_ sut: BaseViewController, isRendering matches: [Match], file: StaticString = #filePath, line: UInt = #line) {
        sut.view.enforceLayoutCycle()
        
        guard sut.numberOfRenderedViews(section: 0) == matches.count else {
            return XCTFail("Expected \(matches.count) matches, got \(sut.numberOfRenderedViews(section: 0)) instead.", file: file, line: line)
        }
        
        matches.enumerated().forEach { index, match in
            assertThat(sut, hasViewConfiguredFor: match, at: index, file: file, line: line)
        }
        
        executeRunLoopToCleanUpReferences()
    }
    
    func assertThat(_ sut: BaseViewController, hasViewConfiguredFor match: Match, at index: Int, file: StaticString = #filePath, line: UInt = #line) {
        let view = sut.matchView(at: index, section: 0)
        
        guard let cell = view as? MatchCell else {
            return XCTFail("Expected \(MatchCell.self) instance, got \(String(describing: view)) instead", file: file, line: line)
        }
        
        XCTAssertEqual(cell.homeText, match.home, "Expected location text to be \(String(describing: match.home)) for match view at index (\(index))", file: file, line: line)
        
        XCTAssertEqual(cell.awayText, match.away, "Expected location text to be \(String(describing: match.away)) for match view at index (\(index))", file: file, line: line)
    }
    
    private func executeRunLoopToCleanUpReferences() {
        RunLoop.current.run(until: Date())
    }
}

extension UIView {
    func enforceLayoutCycle() {
        layoutIfNeeded()
        RunLoop.current.run(until: Date())
    }
}
