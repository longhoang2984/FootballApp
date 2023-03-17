//
//  LoadResourcePresentationAdapter.swift
//  FootballApp
//
//  Created by Cửu Long Hoàng on 16/03/2023.
//

import Combine
import Football
import FootballiOS

final class LoadResourcePresentationAdapter {
    private let teamLoader: () -> AnyPublisher<[Team], Error>
    private let matchLoader: () -> AnyPublisher<[Match], Error>
    private var cancellable: Cancellable?
    private var isLoading = false
    private let viewModel: DisplayViewModel
    private var cancellables = Set<AnyCancellable>()
    private let adapter: TeamLogoAdapter
    private var matches: [Match] = []
    private var teams: [Team] = []
    
    init(viewModel: DisplayViewModel,
         teamLoader: @escaping () -> AnyPublisher<[Team], Error>,
         matchLoader: @escaping () -> AnyPublisher<[Match], Error>,
         adapter: TeamLogoAdapter) {
        self.viewModel = viewModel
        self.matchLoader = matchLoader
        self.teamLoader = teamLoader
        self.adapter = adapter
    }
    
    func loadResource() {
        guard !isLoading else { return }
        
        viewModel.input.send(.showLoading(true))
        isLoading = true
        
        cancellable = teamLoader()
            .dispatchOnMainQueue()
            .handleEvents(receiveCancel: { [weak self] in
                self?.isLoading = false
            })
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.handleError(completion: completion)
                }, receiveValue: { [weak self] teams in
                    self?.cancellable = self?.matchLoader()
                        .dispatchOnMainQueue()
                        .sink(receiveCompletion: { [weak self] completion in
                            self?.handleError(completion: completion)
                        }, receiveValue: { [weak self] matches in
                            self?.isLoading = false
                            self?.viewModel.input.send(.showLoading(false))
                            self?.viewModel.input.send(.showTeams(teams))
                            self?.matches = matches
                            self?.teams = teams
                            self?.adapter.handleSuccessData(teams: teams, matches: matches)
                        })
                })
    }
    
    func filterMatchWithTeamName(teamName: String) {
        var matches = self.matches
        if teamName != "All" {
            matches = self.matches.filter({ $0.home == teamName || $0.away == teamName })
        }
        adapter.handleSuccessData(teams: teams, matches: matches)
    }
    
    private func handleError(completion: Subscribers.Completion<Publishers.HandleEvents<AnyPublisher<Any, Error>>.Failure>) {
        viewModel.input.send(.showLoading(false))
        switch completion {
        case .finished: break
            
        case let .failure(error):
            viewModel.input.send(.showError(error))
        }
        
        isLoading = false
    }
}
