//
//  MainAcceptanceTests.swift
//  FootballAppTests
//
//  Created by Cửu Long Hoàng on 02/04/2023.
//

import XCTest
import Football
import FootballiOS
@testable import FootballApp

final class MainAcceptanceTests: XCTestCase {
    private var previousSection: Int { 0 }
    private var upcomingSection: Int { 1 }
    
    func test_onLaunch_displaysRemoteMatchAndTeamWhenCustomerHasConnectivity() {
        let data = launch(httpClient: .online(response), teamStore: .empty, matchStore: .empty)
        
        XCTAssertEqual(data.numberOfRenderedViews(section: previousSection), 1)
        XCTAssertEqual(data.renderedHomeImageData(at: 0, section: previousSection), makeImageEagle())
        XCTAssertEqual(data.renderedAwayImageData(at: 0, section: previousSection), makeImageDragons())
        
        XCTAssertEqual(data.numberOfRenderedViews(section: upcomingSection), 1)
        XCTAssertEqual(data.renderedHomeImageData(at: 0, section: upcomingSection), makeImagePanda())
        XCTAssertEqual(data.renderedAwayImageData(at: 0, section: upcomingSection), makeImageKing())
    }
    
    func test_onLaunch_displaysCachedMatchAndTeamWhenCustomerHasNoConnectivity() {
        let sharedTeamStore = InMemoryTeamStore.empty
        let sharedMatchStore = InMemoryMatchStore.empty
        
        let onlineData = launch(httpClient: .online(response), teamStore: sharedTeamStore, matchStore: sharedMatchStore)
        XCTAssertEqual(onlineData.numberOfRenderedViews(section: previousSection), 1)
        XCTAssertEqual(onlineData.renderedHomeImageData(at: 0, section: previousSection), makeImageEagle())
        XCTAssertEqual(onlineData.renderedAwayImageData(at: 0, section: previousSection), makeImageDragons())
        
        XCTAssertEqual(onlineData.numberOfRenderedViews(section: upcomingSection), 1)
        XCTAssertEqual(onlineData.renderedHomeImageData(at: 0, section: upcomingSection), makeImagePanda())
        XCTAssertEqual(onlineData.renderedAwayImageData(at: 0, section: upcomingSection), makeImageKing())
        
        let offlineData = launch(httpClient: .offline, teamStore: sharedTeamStore, matchStore: sharedMatchStore)
        XCTAssertEqual(offlineData.numberOfRenderedViews(section: previousSection), 1)
        XCTAssertEqual(offlineData.renderedHomeImageData(at: 0, section: previousSection), makeImageEagle())
        XCTAssertEqual(offlineData.renderedAwayImageData(at: 0, section: previousSection), makeImageDragons())
        
        XCTAssertEqual(offlineData.numberOfRenderedViews(section: upcomingSection), 1)
        XCTAssertEqual(offlineData.renderedHomeImageData(at: 0, section: upcomingSection), makeImagePanda())
        XCTAssertEqual(offlineData.renderedAwayImageData(at: 0, section: upcomingSection), makeImageKing())
    }

    func test_onLaunch_displaysEmptyMatchAndTeamWhenCustomerHasNoConnectivityAndNoCache() {
        let data = launch(httpClient: .offline, teamStore: .empty, matchStore: .empty)
        
        XCTAssertEqual(data.numberOfRenderedViews(section: previousSection), 0)
    }
    
    func test_onHomeSelection_displaysDetails() {
        let detail = showDetailForHomeTeam()
        detail.getData()
        XCTAssertEqual(detail.numberOfRenderedViews(section: previousSection), 1)
        XCTAssertEqual(detail.renderedHomeImageData(at: 0, section: previousSection), makeImageEagle())
        XCTAssertEqual(detail.renderedAwayImageData(at: 0, section: previousSection), makeImageDragons())
        
        XCTAssertEqual(detail.numberOfRenderedViews(section: upcomingSection), 0)
        XCTAssertNil(detail.renderedHomeImageData(at: 0, section: upcomingSection))
        XCTAssertNil(detail.renderedAwayImageData(at: 0, section: upcomingSection))
    }
    
    func test_onAwaySelection_displaysDetails() {
        let detail = showDetailForAwayTeam()
        detail.getData()
        XCTAssertEqual(detail.numberOfRenderedViews(section: previousSection), 0)
        XCTAssertNil(detail.renderedHomeImageData(at: 0, section: previousSection))
        XCTAssertNil(detail.renderedAwayImageData(at: 0, section: previousSection))
        
        XCTAssertEqual(detail.numberOfRenderedViews(section: upcomingSection), 1)
        XCTAssertEqual(detail.renderedHomeImageData(at: 0, section: upcomingSection), makeImagePanda())
        XCTAssertEqual(detail.renderedAwayImageData(at: 0, section: upcomingSection), makeImageKing())
    }
    
    func test_displaysRemoteMatchAndTeamWhenCustomerHasConnectivity_andFilterMatch() {
        let data = launch(httpClient: .online(response), teamStore: .empty, matchStore: .empty)
        
        XCTAssertEqual(data.numberOfRenderedViews(section: previousSection), 1)
        XCTAssertEqual(data.renderedHomeImageData(at: 0, section: previousSection), makeImageEagle())
        XCTAssertEqual(data.renderedAwayImageData(at: 0, section: previousSection), makeImageDragons())
        
        XCTAssertEqual(data.numberOfRenderedViews(section: upcomingSection), 1)
        XCTAssertEqual(data.renderedHomeImageData(at: 0, section: upcomingSection), makeImagePanda())
        XCTAssertEqual(data.renderedAwayImageData(at: 0, section: upcomingSection), makeImageKing())
        
        data.simulateFilterName()
        XCTAssertEqual(data.numberOfRenderedViews(section: previousSection), 1)
        XCTAssertEqual(data.renderedHomeImageData(at: 0, section: previousSection), makeImageEagle())
        XCTAssertEqual(data.renderedAwayImageData(at: 0, section: previousSection), makeImageDragons())
        
        XCTAssertEqual(data.numberOfRenderedViews(section: upcomingSection), 0)
        XCTAssertNil(data.renderedHomeImageData(at: 0, section: upcomingSection))
        XCTAssertNil(data.renderedAwayImageData(at: 0, section: upcomingSection))
    }
    
    func test_displaysRemoteMatchAndTeamWhenCustomerHasConnectivity_simulateFilterField() {
        let data = launch(httpClient: .online(response), teamStore: .empty, matchStore: .empty)
        
        XCTAssertEqual(data.numberOfRenderedViews(section: previousSection), 1)
        XCTAssertEqual(data.renderedHomeImageData(at: 0, section: previousSection), makeImageEagle())
        XCTAssertEqual(data.renderedAwayImageData(at: 0, section: previousSection), makeImageDragons())
        
        XCTAssertEqual(data.numberOfRenderedViews(section: upcomingSection), 1)
        XCTAssertEqual(data.renderedHomeImageData(at: 0, section: upcomingSection), makeImagePanda())
        XCTAssertEqual(data.renderedAwayImageData(at: 0, section: upcomingSection), makeImageKing())
        
        data.simulateOpenTeamPicker()
        data.simulateSelectTeamName(at: 3)
        data.filterTeamName()
        
        XCTAssertEqual(data.numberOfRenderedViews(section: previousSection), 0)
        XCTAssertNil(data.renderedHomeImageData(at: 0, section: previousSection))
        XCTAssertNil(data.renderedAwayImageData(at: 0, section: previousSection))
        
        XCTAssertEqual(data.numberOfRenderedViews(section: upcomingSection), 1)
        XCTAssertEqual(data.renderedHomeImageData(at: 0, section: upcomingSection), makeImagePanda())
        XCTAssertEqual(data.renderedAwayImageData(at: 0, section: upcomingSection), makeImageKing())
    }

    // MARK: - Helpers
    private func launch(
        httpClient: HTTPClientStub = .offline,
        teamStore: InMemoryTeamStore = .empty,
        matchStore: InMemoryMatchStore = .empty
    ) -> MainViewController {
        let sut = SceneDelegate(httpClient: httpClient,
                                teamStore: teamStore,
                                matchStore: matchStore)
        sut.window = UIWindow(frame: CGRect(x: 0, y: 0,
                                            width: UIScreen.main.bounds.width,
                                            height: UIScreen.main.bounds.height))
        sut.setUpWindow()

        let nav = sut.window?.rootViewController as? UINavigationController
        let vc = nav?.topViewController as! MainViewController
        vc.loadViewIfNeeded()
        return vc
    }
    
    private func showDetailForHomeTeam() -> TeamDetailViewController {
        let data = launch(httpClient: .online(response), teamStore: .empty, matchStore: .empty)
        
        data.simulateTapOnHomeTeamName(at: 0, section: previousSection)
        RunLoop.current.run(until: Date())
        
        let nav = data.navigationController
        let detail = nav?.topViewController as! TeamDetailViewController
        detail.loadViewIfNeeded()
        return detail
    }
    
    private func showDetailForAwayTeam() -> TeamDetailViewController {
        let data = launch(httpClient: .online(response), teamStore: .empty, matchStore: .empty)
        
        data.simulateTapOnAwayTeamName(at: 0, section: upcomingSection)
        RunLoop.current.run(until: Date())
        
        let nav = data.navigationController
        let detail = nav?.topViewController as! TeamDetailViewController
        detail.loadViewIfNeeded()
        return detail
    }

    private func response(for url: URL) -> (Data, HTTPURLResponse) {
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
        return (makeData(for: url), response)
    }

    private func makeData(for url: URL) -> Data {
        switch url.path {
        case "/dragons.png": return makeImageDragons()
        case "/eagle.png": return makeImageEagle()
        case "/panda.png": return makeImagePanda()
        case "/kings.png": return makeImageKing()

        case "/teams":
            return makeTeamData()

        case "/teams/matches":
            return makeMatchData()

        default:
            return Data()
        }
    }
    
    private func makeMatchData() -> Data {
        return try! JSONSerialization.data(withJSONObject: ["matches":
        [
            "previous": [
                ["date": "2022-04-23T18:00:00.000Z",
                 "description": "Team Cool Eagles vs. Team Red Dragons",
                 "home": "Team Cool Eagles",
                 "away": "Team Red Dragons",
                 "winner": "Team Red Dragons",
                 "image": "https://any-url.com/highlights.mp4"]
            ],
            "upcoming": [
                ["date": "2023-08-13T20:00:00.000Z",
                 "description": "Team Angry Pandas vs. Team Win Kings",
                 "home": "Team Angry Pandas",
                 "away": "Team Win Kings"]
            ],
        ]])
    }
    
    private func makeTeamData() -> Data {
        return try! JSONSerialization.data(withJSONObject: ["teams": [
            ["id":"767ec50c-7fdb-4c3d-98f9-d6727ef8252b","name":"Team Red Dragons","logo":"https://tstzj.s3.amazonaws.com/dragons.png"],
            ["id":"7b4d8114-742b-4410-971a-500162101158","name":"Team Cool Eagles","logo":"https://tstzj.s3.amazonaws.com/eagle.png"],
            ["id":"a3034ee6-eb8b-11ec-8ea0-0242ac120002","name":"Team Angry Pandas","logo":"https://tstzj.s3.amazonaws.com/panda.png"],
            ["id":"01490dfe-0bc7-42ad-b471-2fba2b9b8f5e","name":"Team Win Kings","logo":"https://tstzj.s3.amazonaws.com/kings.png"]]])
    }
    
    private func makeImageDragons() -> Data { UIImage.make(withColor: .red).pngData()! }
    private func makeImageEagle() -> Data { UIImage.make(withColor: .green).pngData()! }
    private func makeImagePanda() -> Data { UIImage.make(withColor: .brown).pngData()! }
    private func makeImageKing() -> Data { UIImage.make(withColor: .yellow).pngData()! }
}

extension MainViewController {
    func simulateSelectTeamName(at row: Int = 0, component: Int = 0) {
        guard teamPickerView.numberOfComponents > 0 else { return }
        guard teamPickerView.numberOfRows(inComponent: component) > row else { return }
        teamPickerView.selectRow(row, inComponent: component, animated: false)
    }
    
    func simulateFilterName() {
        simulateSelectTeamName(at: 1)
        filterTeamName()
    }
    
    func simulateOpenTeamPicker() {
        filterField.simulate(event: .touchUpInside)
    }
}
