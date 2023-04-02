//
//  DetailSnapshotTests.swift
//  
//
//  Created by Cửu Long Hoàng on 02/04/2023.
//

import XCTest
import Football
import Combine
import FootballiOS

final class DetailSnapshotTests: XCTestCase {

    func test_emptyList() {
        let sut = makeSUT()
        sut.display([])

        assert(snapshot: sut.snapshot(for: .iPhone13(style: .light)), named: "EMPTY_LIST_light")
        assert(snapshot: sut.snapshot(for: .iPhone13(style: .dark)), named: "EMPTY_LIST_dark")
    }
    
    func test_matchList_withEmptyImage() {
        let sut = makeSUT()
        
        let stubs = [Stub(homeLogo: nil,
                          awayLogo: nil,
                          home: uniqueTeam(teamName: "Team A"),
                          away: uniqueTeam(teamName: "Team B"),
                         isPrevious: true),
                     Stub(homeLogo: nil,
                          awayLogo: nil,
                          home: uniqueTeam(teamName: "Team A"),
                          away: uniqueTeam(teamName: "Team D")),]
        sut.display(controllers(stubs: stubs))
        sut.displayMatchesInfo(previous: 1, upcoming: 1)
        
        assert(snapshot: sut.snapshot(for: .iPhone13(style: .light)), named: "CONTROLLER_LIST_light")
        assert(snapshot: sut.snapshot(for: .iPhone13(style: .dark)), named: "CONTROLLER_LIST_dark")
    }
    
    func test_matchList_withImages() {
        let sut = makeSUT()
        
        let stubs = [
            Stub(homeLogo: .make(withColor: .red),
                 awayLogo: .make(withColor: .blue),
                 home: uniqueTeam(teamName: "Team A"),
                 away: uniqueTeam(teamName: "Team B"),
                isPrevious: true),
            Stub(homeLogo: .make(withColor: .brown),
                 awayLogo: .make(withColor: .cyan),
                 home: uniqueTeam(teamName: "Team A"),
                 away: uniqueTeam(teamName: "Team D")),
        ]
        sut.display(controllers(stubs: stubs))
        sut.displayMatchesInfo(previous: 1, upcoming: 1)
        
        assert(snapshot: sut.snapshot(for: .iPhone13(style: .light)), named: "CONTROLLER_LIST_WITH_IMAGES_light")
        assert(snapshot: sut.snapshot(for: .iPhone13(style: .dark)), named: "CONTROLLER_LIST_WITH_IMAGES_dark")
    }
    
    // MARK: - Helpers
    
    private func makeSUT() -> (TeamDetailViewController) {
        let sut = TeamDetailViewController()
        sut.loadViewIfNeeded()
        sut.displayImage(img: .make(withColor: .blue))
        return (sut)
    }

}
