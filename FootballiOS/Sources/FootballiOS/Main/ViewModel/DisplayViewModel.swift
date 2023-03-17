//
//  DisplayViewModel.swift
//  
//
//  Created by Cửu Long Hoàng on 17/03/2023.
//

import Foundation
import Combine
import Football

public class DisplayViewModel {
    public init() {}
    
    public enum Input {
        case getDatas
        case filterMatches(teamName: String)
        case showLoading(Bool)
        case showError(Error)
        case showTeams([Team])
        case showControllers(controllers: [CellController])
        case showAllData(teams: [Team], matches: [Match])
    }
    
    public enum Output {
        case displayLoading(Bool)
        case displayError(Error)
        case displayTeamNames([String])
        case displayControllers([CellController])
        case displayAllData(([Team], [Match]))
    }
    
    private let output: PassthroughSubject<Output, Never> = .init()
    private var cancellables = Set<AnyCancellable>()
    public var onGetData: (() -> Void)?
    public var filterMatch: ((_ teamName: String) -> Void)?
    private let input = PassthroughSubject<Input, Never>()
    private var controllers = [CellController]()
    
    public func send(_ input: Input) {
        self.input.send(input)
    }
    
    public func transform() -> AnyPublisher<Output, Never> {
        input.sink { [weak self] event in
            guard let self = self else { return }
            switch event {
            case .getDatas:
                self.onGetData?()
            case let .showLoading(loading):
                self.output.send(.displayLoading(loading))
            case let .showTeams(teams):
                self.output.send(.displayTeamNames(teams.map({ $0.name })))
            case let .showControllers(controllers):
                self.output.send(.displayControllers(controllers))
            case let .filterMatches(teamName):
                self.filterMatch?(teamName)
            case let .showError(error):
                self.output.send(.displayError(error))
            case let .showAllData(teams, matches):
                self.output.send(.displayAllData((teams, matches)))
            }
        }
        .store(in: &cancellables)
        
        return output.eraseToAnyPublisher()
    }
}
