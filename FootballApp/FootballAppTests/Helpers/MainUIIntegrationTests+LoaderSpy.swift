//
//  MainUIIntegrationTests.swift
//  FootballAppTests
//
//  Created by Cửu Long Hoàng on 02/04/2023.
//

import Foundation
import Football
import FootballiOS
import Combine
@testable import FootballApp

extension MainUIIntegrationTests {
    class LoaderSpy {
        
        // MARK: - TeamLoader
        private var teamRequests = [PassthroughSubject<[Team], Error>]()
        
        var loadTeamCallCount: Int {
            return teamRequests.count
        }
        
        func loadPublisher() -> AnyPublisher<[Team], Error> {
            let publisher = PassthroughSubject<[Team], Error>()
            teamRequests.append(publisher)
            return publisher.eraseToAnyPublisher()
        }
        
        func completeTeamLoadingWithError(at index: Int = 0) {
            teamRequests[index].send(completion: .failure(anyNSError()))
        }
        
        func completeTeamLoading(with teams: [Team] = [], at index: Int = 0) {
            teamRequests[index].send(teams)
        }
        
        // MARK: - TeamLogoDataLoader
        
        private var homeImageRequests = [(url: URL, publisher: PassthroughSubject<Data, Error>)]()
        
        var loadedImageURLs: [URL] {
            return homeImageRequests.map { $0.url }
        }
        
        private(set) var cancelledImageURLs = [URL]()
        
        func loadTeamLogoPublisher(from url: URL) -> AnyPublisher<Data, Error> {
            let publisher = PassthroughSubject<Data, Error>()
            homeImageRequests.append((url, publisher))
            return publisher.handleEvents(receiveCancel: { [weak self] in
                self?.cancelledImageURLs.append(url)
            }).eraseToAnyPublisher()
        }
        
        func completeImageLoading(with imageData: Data = Data(), at index: Int = 0) {
            homeImageRequests[index].publisher.send(imageData)
            homeImageRequests[index].publisher.send(completion: .finished)
        }
        
        func completeImageLoadingWithError(at index: Int = 0) {
            homeImageRequests[index].publisher.send(completion: .failure(anyNSError()))
        }
        
        // MARK: - MatchLoader
        private var matchRequests = [PassthroughSubject<[Match], Error>]()
        
        var loadMatchCallCount: Int {
            return matchRequests.count
        }
        
        func loadMatchPublisher() -> AnyPublisher<[Match], Error> {
            let publisher = PassthroughSubject<[Match], Error>()
            matchRequests.append(publisher)
            return publisher.eraseToAnyPublisher()
        }
        
        func completeMatchLoadingWithError(at index: Int = 0) {
            matchRequests[index].send(completion: .failure(anyNSError()))
        }
        
        func completeMatchLoading(with matches: [Match] = [], at index: Int = 0) {
            matchRequests[index].send(matches)
        }
    }
}
