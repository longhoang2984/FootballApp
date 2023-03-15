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
        case showGetDataSuccess(teams: [Team], matches: [Any])
        case filterMatches(teamName: String)
    }
    
    public enum Output {
        case didStartLoading
        case didEndLoading
        case getDataDidFail(error: Error)
        case getDataSuccess(teams: [Team], matches: [Any])
    }
    
    private let output: PassthroughSubject<Output, Never> = .init()
    private var cancellables = Set<AnyCancellable>()
    private var teams = [Team]()
    public var onGetData: (() -> Void)?
    
    public func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { event in
            switch event {
            case .getDatas:
                self.output.send(.didStartLoading)
                self.onGetData?()
            case let .showGetDataDidFail(error):
                self.output.send(.didEndLoading)
                self.output.send(.getDataDidFail(error: error))
            case let .filterMatches(teamName):
                break
            case let .showGetDataSuccess(teams, matches):
                self.output.send(.didEndLoading)
                self.teams = teams
                self.handleSuccessData(teams: teams, matches: matches)
            }
        }
        .store(in: &cancellables)
        
        return output.eraseToAnyPublisher()
    }
    
    private func handleSuccessData(teams: [Team], matches: [Any]) {
        
    }
}
