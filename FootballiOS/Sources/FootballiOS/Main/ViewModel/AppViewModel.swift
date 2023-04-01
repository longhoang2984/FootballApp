//
//  AppViewModel.swift
//  
//
//  Created by Cửu Long Hoàng on 17/03/2023.
//

import Foundation
import Combine
import Football

public protocol ViewModel {
    var cancellables: Set<AnyCancellable> { get }
    var onGetData: (() -> Void)? { get set }
}

public class AppViewModel: ViewModel {
    public var cancellables: Set<AnyCancellable>
    
    public var onGetData: (() -> Void)?
    
    private let input: PassthroughSubject<Input, Never>
    private let output: PassthroughSubject<Output, Never>
    
    public init(input: PassthroughSubject<Input, Never>,
                output: PassthroughSubject<Output, Never>,
                cancellables: Set<AnyCancellable> = []) {
        self.input = input
        self.output = output
        self.cancellables = cancellables
    }
    
    public enum Input {
        case getDatas
        case filterMatches(teamName: String)
        case showLoading(Bool)
        case showError(Error)
        case showTeams([Team])
        case showControllers(controllers: [[CellController]])
        case showAllData(teams: [Team], matches: [Match])
    }

    public enum Output {
        case displayLoading(Bool)
        case displayError(Error)
        case displayTeamNames([String])
        case displayControllers([[CellController]])
        case displayAllData(([Team], [Match]))
    }

    public var filterMatch: ((_ teamName: String) -> Void)?
    
    public func send(_ input: Input) {
        self.input.send(input)
    }
    
    public func transform() -> AnyPublisher<Output, Never> {
        return output.eraseToAnyPublisher()
    }
    
    deinit {
        print("DEALLOCATEDDDDD")
    }
}
