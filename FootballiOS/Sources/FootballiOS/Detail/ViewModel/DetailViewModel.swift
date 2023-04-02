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

public class DetailViewModel: ViewModel {
    private let input: PassthroughSubject<Input, Never>
    private let output: PassthroughSubject<Output, Never>
    private(set) var team: Team
    private(set) var image: UIImage?
    
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
        case showSelectionTeam(team: Team, image: UIImage?)
        case showMatchesInfo(previous: Int, upcoming: Int)
    }
    
    public enum Output {
        case displayDetai(_ team: Team, _ image: UIImage?)
        case displayLoading(Bool)
        case displayError(Error)
        case displayControllers([[CellController]])
        case displayAllData(([Team], [Match]))
        case displaySelectionTeam(team: Team, image: UIImage?)
        case displayMatchesInfo(previous: Int, upcoming: Int)
    }
    
    public var cancellables = Set<AnyCancellable>()
    public var onGetData: (() -> Void)?
    private var controllers = [CellController]()
    
    public func send(_ input: Input) {
        self.input.send(input)
    }
    
    public func transform() -> AnyPublisher<Output, Never> {
        input.sink { [weak self] event in
            switch event {
            case .getDatas:
                self?.onGetData?()
            case let .showLoading(loading):
                self?.output.send(.displayLoading(loading))
            case let .showControllers(controllers):
                self?.output.send(.displayControllers(controllers))
            case let .showError(error):
                self?.output.send(.displayError(error))
            case let .showAllData(teams, matches):
                self?.output.send(.displayAllData((teams, matches)))
            case let .showSelectionTeam(team, image):
                self?.output.send(.displaySelectionTeam(team: team, image: image))
            case let .showMatchesInfo(previous, upcoming):
                self?.output.send(.displayMatchesInfo(previous: previous, upcoming: upcoming))
            }
        }
        .store(in: &cancellables)
        return output.eraseToAnyPublisher()
    }
    
    public func cancel() {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
    }
}
