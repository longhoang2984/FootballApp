//
//  DetailViewModel.swift
//  
//
//  Created by Cửu Long Hoàng on 31/03/2023.
//

import Foundation
import Combine
import Football
import UIKit

public class DetailViewModel {
    private let input: PassthroughSubject<Input, Never>
    private let output: PassthroughSubject<Output, Never>
    private let team: Team
    private let image: UIImage?
    
    public init(team: Team,
                image: UIImage?,
        input: PassthroughSubject<Input, Never>,
        output: PassthroughSubject<Output, Never>) {
        self.input = input
        self.output = output
        self.team = team
        self.image = image
    }
    
    public enum Input {
        case getDatas
        case showLoading(Bool)
        case showError(Error)
        case showControllers(controllers: [[CellController]])
        case showAllData(teams: [Team], matches: [Match])
    }
    
    public enum Output {
        case displayDetai(_ team: Team, _ image: UIImage?)
        case displayLoading(Bool)
        case displayError(Error)
        case displayControllers([[CellController]])
        case displayAllData(([Team], [Match]))
    }
    
    private var cancellables = Set<AnyCancellable>()
    public var onGetData: (() -> Void)?
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
            case let .showControllers(controllers):
                self.output.send(.displayControllers(controllers))
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
