//
//  DetailUIComposer.swift
//  FootballApp
//
//  Created by Cửu Long Hoàng on 01/04/2023.
//

import UIKit
import Combine
import Football
import FootballiOS

public final class DetailUIComposer {
    private init() {}
    
    public static func detailComposedWith(
        team: Team,
        image: UIImage?,
        teamLoader: @escaping () -> AnyPublisher<[Team], Error>,
        matchLoader: @escaping () -> AnyPublisher<[Match], Error>,
        imageLoader: @escaping (URL) -> TeamLogoDataLoader.Publisher,
        awayImageLoader: @escaping (URL) -> TeamLogoDataLoader.Publisher,
        selection: @escaping (_ team: Team, _ image: UIImage?) -> Void = { _, _ in }
    ) -> TeamDetailViewController {
        
        let input = PassthroughSubject<DetailViewModel.Input, Never>()
        let output = PassthroughSubject<DetailViewModel.Output, Never>()
        let viewModel = DetailViewModel(team: team,
                                        image: image,
                                        input: input,
                                        output: output)
        
        let detailVC = makeDetailViewController()
        let logoAdapter = TeamLogoAdapter(viewModel: viewModel,
                                          controller: detailVC,
                                          imageLoader: imageLoader,
                                          awayImageLoader: awayImageLoader,
                                          selection: { selectionTeam,image in
            if team != selectionTeam {
                selection(selectionTeam, image)
            }
        },
                                          onShowMatchesInfo: { input.send(.showMatchesInfo(previous: $0, upcoming: $1)) })
        
        let adapter = LoadResourcePresentationAdapter(teamLoader: teamLoader,
                                                      matchLoader: matchLoader,
                                                      adapter: logoAdapter,
                                                      onLoading: { input.send(.showLoading($0)) },
                                                      onError: { input.send(.showError($0)) },
                                                      onShowTeams: { _ in },
                                                      onShowData: { teams, matches in
            let matches = matches.filter { $0.home == team.name || $0.away == team.name }
            let controllers = logoAdapter.handleSuccessData(teams: teams, matches: matches)
            input.send(.showControllers(controllers: controllers))
        })
        
        bind(input: input, output: output, viewModel: viewModel)
        outoutSink(output: output, detailVC: detailVC, viewModel: viewModel)
        
        detailVC.onGetData = {
            input.send(.showSelectionTeam(team: team, image: image))
            adapter.loadResource()
        }
        
        return detailVC
    }
    
    private static func bind(input: PassthroughSubject<DetailViewModel.Input, Never>,
                             output: PassthroughSubject<DetailViewModel.Output, Never>,
                             viewModel: DetailViewModel) {
        input.sink { event in
            switch event {
            case .getDatas:
                viewModel.onGetData?()
            case let .showLoading(loading):
                output.send(.displayLoading(loading))
            case let .showControllers(controllers):
                output.send(.displayControllers(controllers))
            case let .showError(error):
                output.send(.displayError(error))
            case let .showAllData(teams, matches):
                output.send(.displayAllData((teams, matches)))
            case let .showSelectionTeam(team, image):
                output.send(.displaySelectionTeam(team: team, image: image))
            case let .showMatchesInfo(previous, upcoming):
                output.send(.displayMatchesInfo(previous: previous, upcoming: upcoming))
            }
        }
        .store(in: &viewModel.cancellables)
    }
    
    private static func outoutSink(output: PassthroughSubject<DetailViewModel.Output, Never>,
                                   detailVC: TeamDetailViewController,
                                   viewModel: DetailViewModel) {
        output
            .eraseToAnyPublisher()
            .sink { ev in
                switch ev {
                case let .displayControllers(controllers):
                    detailVC.display(controllers)
                case let .displayError(error):
                    detailVC.showErrorAlert(error: error)
                case let .displaySelectionTeam(team, image):
                    detailVC.displayImage(img: image)
                    detailVC.title = team.name
                case let .displayMatchesInfo(previous, upcoming):
                    detailVC.displayMatchesInfo(previous: previous, upcoming: upcoming)
                default: break
                }
            }
            .store(in: &viewModel.cancellables)
    }
    
    private static func makeDetailViewController() -> TeamDetailViewController {
        TeamDetailViewController()
    }
}
