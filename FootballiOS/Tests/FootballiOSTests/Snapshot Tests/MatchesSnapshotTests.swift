//
//  MatchesSnapshotTests.swift
//  
//
//  Created by Cửu Long Hoàng on 17/03/2023.
//

import XCTest
import Football
import Combine
@testable import FootballiOS

final class MatchesSnapshotTests: XCTestCase {

    func test_emptyList() {
        let (sut, _) = makeSUT()
        sut.display([])

        assert(snapshot: sut.snapshot(for: .iPhone13(style: .light)), named: "EMPTY_LIST_light")
        assert(snapshot: sut.snapshot(for: .iPhone13(style: .dark)), named: "EMPTY_LIST_dark")
    }
    
    func test_loadingView() {
        let (sut, _) = makeSUT()
        sut.startLoading()

        assert(snapshot: sut.snapshot(for: .iPhone13(style: .light)), named: "LOADING_light")
        assert(snapshot: sut.snapshot(for: .iPhone13(style: .dark)), named: "LOADING_dark")
    }
    
    func test_matchList_withEmptyImage() {
        let (sut, _) = makeSUT()
        
        let stubs = [Stub(homeLogo: nil,
                          awayLogo: nil,
                          home: uniqueTeam(teamName: "Team A"),
                          away: uniqueTeam(teamName: "Team B"),
                         isPrevious: true),
                     Stub(homeLogo: nil,
                          awayLogo: nil,
                          home: uniqueTeam(teamName: "Team C"),
                          away: uniqueTeam(teamName: "Team D")),]
        sut.display(controllers(stubs: stubs))
        
        assert(snapshot: sut.snapshot(for: .iPhone13(style: .light)), named: "CONTROLLER_LIST_light")
        assert(snapshot: sut.snapshot(for: .iPhone13(style: .dark)), named: "CONTROLLER_LIST_dark")
    }
    
    func test_matchList_withImages() {
        let (sut, _) = makeSUT()
        
        let stubs = [
            Stub(homeLogo: .make(withColor: .red),
                 awayLogo: .make(withColor: .blue),
                 home: uniqueTeam(teamName: "Team A"),
                 away: uniqueTeam(teamName: "Team B"),
                isPrevious: true),
            Stub(homeLogo: .make(withColor: .brown),
                 awayLogo: .make(withColor: .cyan),
                 home: uniqueTeam(teamName: "Team C"),
                 away: uniqueTeam(teamName: "Team D")),
        ]
        sut.display(controllers(stubs: stubs))
        
        assert(snapshot: sut.snapshot(for: .iPhone13(style: .light)), named: "CONTROLLER_LIST_WITH_IMAGES_light")
        assert(snapshot: sut.snapshot(for: .iPhone13(style: .dark)), named: "CONTROLLER_LIST_WITH_IMAGES_dark")
    }
    
    // MARK: - Helpers
    
    private func makeSUT() -> (sut: MainViewController, spy: ViewModelSpy) {
        let input = PassthroughSubject<AppViewModel.Input, Never>()
        let output = PassthroughSubject<AppViewModel.Output, Never>()
        let spy = ViewModelSpy(input: input, output: output)
        let sut = MainViewController(viewModel: spy)
        sut.loadViewIfNeeded()
        return (sut, spy)
    }
    
    private class ViewModelSpy: AppViewModel {}

}


