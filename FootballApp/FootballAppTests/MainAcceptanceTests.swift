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
        return try! JSONSerialization.data(withJSONObject: ["teams": [["id":"767ec50c-7fdb-4c3d-98f9-d6727ef8252b","name":"Team Red Dragons","logo":"https://tstzj.s3.amazonaws.com/dragons.png"],["id":"7b4d8114-742b-4410-971a-500162101158","name":"Team Cool Eagles","logo":"https://tstzj.s3.amazonaws.com/eagle.png"],["id":"a3034ee6-eb8b-11ec-8ea0-0242ac120002","name":"Team Angry Pandas","logo":"https://tstzj.s3.amazonaws.com/panda.png"],["id":"01490dfe-0bc7-42ad-b471-2fba2b9b8f5e","name":"Team Win Kings","logo":"https://tstzj.s3.amazonaws.com/kings.png"]]])
    }
    
    private func makeImageDragons() -> Data { UIImage.make(withColor: .red).pngData()! }
    private func makeImageEagle() -> Data { UIImage.make(withColor: .green).pngData()! }
    private func makeImagePanda() -> Data { UIImage.make(withColor: .brown).pngData()! }
    private func makeImageKing() -> Data { UIImage.make(withColor: .yellow).pngData()! }
}

extension BaseViewController {
    public override func loadViewIfNeeded() {
        super.loadViewIfNeeded()
        
        collectionView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
    }
    
    var isShowingLoadingIndicator: Bool {
        return loadingIndicator.parent != nil
    }
    
    func numberOfItems(in section: Int) -> Int {
        collectionView.numberOfSections > section ? collectionView.numberOfItems(inSection: section) : 0
    }
    
    func cell(item: Int, section: Int) -> UICollectionViewCell? {
        guard numberOfItems(in: section) > item else {
            return nil
        }
        let ds = collectionView.dataSource
        let index = IndexPath(item: item, section: section)
        return ds?.collectionView(collectionView, cellForItemAt: index)
    }
}

extension BaseViewController {
    
    @discardableResult
    func simulateMatchViewVisible(at index: Int, section: Int) -> MatchCell? {
        return matchView(at: index, section: section) as? MatchCell
    }
    
    @discardableResult
    func simulateMatchBecomingVisibleAgain(at item: Int, section: Int) -> MatchCell? {
        let view = simulateMatchViewNotVisible(at: item, section: section)
        
        let delegate = collectionView.delegate
        let index = IndexPath(item: item, section: section)
        delegate?.collectionView?(collectionView, willDisplay: view!, forItemAt: index)
        
        return view
    }
    
    @discardableResult
    func simulateMatchViewNotVisible(at item: Int, section: Int) -> MatchCell? {
        let view = simulateMatchViewVisible(at: item, section: section)
        
        let delegate = collectionView.delegate
        let index = IndexPath(item: item, section: section)
        delegate?.collectionView?(collectionView, didEndDisplaying: view!, forItemAt: index)
        
        return view
    }
    
    func simulateTapOnHomeTeamName(at item: Int, section: Int) {
        let datasource = collectionView.dataSource
        let index = IndexPath(item: item, section: section)
        let cell = datasource?.collectionView(collectionView, cellForItemAt: index) as? MatchCell
        cell?.selection?(true)
    }
    
    func simulateTapOnAwayTeamName(at item: Int, section: Int) {
        let datasource = collectionView.dataSource
        let index = IndexPath(item: item, section: section)
        let cell = datasource?.collectionView(collectionView, cellForItemAt: index) as? MatchCell
        cell?.selection?(false)
    }
    
    func simulateMatchViewNearVisible(at item: Int, section: Int) {
        let ds = collectionView.prefetchDataSource
        let index = IndexPath(item: item, section: section)
        ds?.collectionView(collectionView, prefetchItemsAt: [index])
    }
    
    func simulateMatchViewNotNearVisible(at item: Int, section: Int) {
        simulateMatchViewNearVisible(at: item, section: section)
        
        let ds = collectionView.prefetchDataSource
        let index = IndexPath(item: item, section: section)
        ds?.collectionView?(collectionView, cancelPrefetchingForItemsAt: [index])
    }
    
    func renderedHomeImageData(at index: Int, section: Int) -> Data? {
        return simulateMatchViewVisible(at: index, section: section)?.renderedHomeImage
    }
    
    func renderedAwayImageData(at index: Int, section: Int) -> Data? {
        return simulateMatchViewVisible(at: index, section: section)?.renderedAwayImage
    }
    
    func numberOfRenderedViews(section: Int) -> Int {
        numberOfItems(in: section)
    }
    
    func matchView(at item: Int, section: Int) -> UICollectionViewCell? {
        cell(item: item, section: section)
    }
    
    private var previousSection: Int { 0 }
    private var upcomingSection: Int { 1 }
}

extension UIView {
    func simulate() {
        
    }
}

extension MatchCell {
    var isShowingHomeImageLoadingIndicator: Bool {
        return homeImageContainer.isShimmering
    }
    
    var isShowingAwayImageLoadingIndicator: Bool {
        return awayImageContainer.isShimmering
    }
    
    var homeText: String? {
        return homeNameLabel.text
    }
    
    var awayText: String? {
        return awayNameLabel.text
    }
    
    var dateText: String? {
        return dateLabel.text
    }
    
    var timeText: String? {
        return timeLabel.text
    }
    
    var renderedHomeImage: Data? {
        return homeLogoImageView.image?.pngData()
    }
    
    var renderedAwayImage: Data? {
        return awayLogoImageView.image?.pngData()
    }
}
