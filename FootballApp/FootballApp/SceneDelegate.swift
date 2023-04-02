//
//  SceneDelegate.swift
//  FootballApp
//
//  Created by Cửu Long Hoàng on 14/03/2023.
//

import UIKit
import Football
import FootballiOS
import CoreData
import Combine

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    private lazy var httpClient: HTTPClient = {
        URLSessionHTTPClient(session: URLSession(configuration: .ephemeral))
    }()
    
    private lazy var teamStore: TeamStore & TeamLogoDataStore = {
        do {
            return try CoreDataTeamStore(
                storeURL: NSPersistentContainer
                    .defaultDirectoryURL()
                    .appendingPathComponent("team-store.sqlite"))
        } catch {
            assertionFailure("Failed to instantiate CoreData store with error: \(error.localizedDescription)")
            return NullStore()
        }
    }()
    
    private lazy var matchStore: MatchStore = {
        do {
            return try CoreDataMatchStore(
                storeURL: NSPersistentContainer
                    .defaultDirectoryURL()
                    .appendingPathComponent("match-store.sqlite"))
        } catch {
            assertionFailure("Failed to instantiate CoreData store with error: \(error.localizedDescription)")
            return NullStore()
        }
    }()
    
    private lazy var localTeamLoader: LocalTeamLoader = {
        LocalTeamLoader(store: teamStore)
    }()
    
    private lazy var localMatchLoader: LocalMatchLoader = {
        LocalMatchLoader(store: matchStore)
    }()
    
    private lazy var baseURL = URL(string: "https://jmde6xvjr4.execute-api.us-east-1.amazonaws.com")!
    
    private lazy var navigationController = UINavigationController(
        rootViewController: MainUIComposer.mainComposedWith(teamLoader: makeRemoteTeamLoaderWithLocalFallback,
                                                            matchLoader: makeRemoteMatchLoaderWithLocalFallback,
                                                            imageLoader: makeLocalImageLoaderWithRemoteFallback,
                                                            awayImageLoader: makeLocalImageLoaderWithRemoteFallback,
                                                            selection: { self.showDetail(team: $0, image: $1) }))
    
    convenience init(httpClient: HTTPClient,
                     teamStore: TeamStore & TeamLogoDataStore,
                     matchStore: MatchStore) {
        self.init()
        self.httpClient = httpClient
        self.teamStore = teamStore
        self.matchStore = matchStore
    }
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        setUpWindow()
    }
    
    func setUpWindow() {
        navigationController.setNavigationBarHidden(false, animated: false)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
    
    private func showDetail(team: Team, image: UIImage?, animated: Bool = true) {
        let vc = DetailUIComposer.detailComposedWith(team: team,
                                            image: image,
                                            teamLoader: localTeamLoader.loadPublisher,
                                            matchLoader: localMatchLoader.loadPublisher,
                                            imageLoader: makeLocalImageLoaderWithRemoteFallback,
                                            awayImageLoader: makeLocalImageLoaderWithRemoteFallback,
                                                     selection: { [weak self] team, img in
            // Avoid Loop Detail View
            self?.navigationController.popViewController(animated: false)
            self?.showDetail(team: team, image: img, animated: false)
        })
        navigationController.pushViewController(vc, animated: animated)
    }
    
    private func makeRemoteTeamLoaderWithLocalFallback() -> AnyPublisher<[Team], Error> {
        makeRemoteTeamLoader()
            .caching(to: localTeamLoader)
            .fallback(to: localTeamLoader.loadPublisher)
            .eraseToAnyPublisher()
    }
    
    private func makeRemoteTeamLoader() -> AnyPublisher<[Team], Error> {
        let url = TeamEndpoint.get.url(baseURL: baseURL)
        
        return httpClient
            .getPublisher(url: url)
            .tryMap(TeamMapper.map)
            .eraseToAnyPublisher()
    }
    
    private func makeRemoteMatchLoaderWithLocalFallback() -> AnyPublisher<[Match], Error> {
        makeRemoteMatchLoader()
            .caching(to: localMatchLoader)
            .fallback(to: localMatchLoader.loadPublisher)
            .eraseToAnyPublisher()
    }
    
    private func makeRemoteMatchLoader() -> AnyPublisher<[Match], Error> {
        let url = MatchEndpoint.get.url(baseURL: baseURL)
        
        return httpClient
            .getPublisher(url: url)
            .tryMap(MatchMapper.map)
            .eraseToAnyPublisher()
    }
    
    private func makeLocalImageLoaderWithRemoteFallback(url: URL) -> LocalTeamLogoDataLoader.Publisher {
        let localImageLoader = LocalTeamLogoDataLoader(store: teamStore)
        
        return localImageLoader
            .loadImageDataPublisher(from: url)
            .fallback(to: { [httpClient] in
                return httpClient
                    .getPublisher(url: url)
                    .tryMap(TeamLogoDataMapper.map)
                    .caching(to: localImageLoader, using: url)
                    .eraseToAnyPublisher()
            })
            .eraseToAnyPublisher()
    }
}

