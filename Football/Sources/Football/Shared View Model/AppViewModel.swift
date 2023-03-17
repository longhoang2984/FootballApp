//
//  File.swift
//  
//
//  Created by Cửu Long Hoàng on 15/03/2023.
//

import Combine

public final class AppViewModel {
    
    public init() {
        
    }
    
    public enum Input {
        case getDatas
        case showGetDataDidFail(error: Error)
        case showGetDataSuccess(teams: [Team], matches: [Match])
        case filterMatches(teamName: String)
    }
    
    public enum Output {
        case didStartLoading
        case didEndLoading
        case getDataDidFail(error: Error)
        case getDataSuccess(teams: [Team], matches: [Match])
    }
    
    private let output: PassthroughSubject<Output, Never> = .init()
    private var cancellables = Set<AnyCancellable>()
    private var teams = [Team]()
    private var matches = [Match]()
    public var onGetData: (() -> Void)?
    public let input = PassthroughSubject<AppViewModel.Input, Never>()
    
    public func transform() -> AnyPublisher<Output, Never> {
        input.sink { [weak self] event in
            guard let self = self else { return }
            switch event {
            case .getDatas:
                self.output.send(.didStartLoading)
                self.onGetData?()
            case let .showGetDataDidFail(error):
                self.output.send(.didEndLoading)
                self.output.send(.getDataDidFail(error: error))
            case let .filterMatches(teamName):
                var matches = [Match]()
                self.matches.forEach { m in
                    if m.home == teamName || m.away == teamName {
                        matches.append(m)
                    }
                }
                self.handleSuccessData(teams: self.teams, matches: matches)
            case let .showGetDataSuccess(teams, matches):
                self.output.send(.didEndLoading)
                self.teams = teams
                self.matches = matches
                self.handleSuccessData(teams: teams, matches: matches)
            }
        }
        .store(in: &cancellables)
        
        return output.eraseToAnyPublisher()
    }
    
    private func handleSuccessData(teams: [Team], matches: [Match]) {
        output.send(.getDataSuccess(teams: teams, matches: matches))
    }
}
