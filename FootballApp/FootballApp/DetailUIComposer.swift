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
        
        let detailVC = makeDetailViewController(viewModel: viewModel)
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
        
        viewModel.onGetData = {
            input.send(.showSelectionTeam(team: team, image: image))
            adapter.loadResource()
        }
        
        return detailVC
    }
    
    
    
    private static func makeDetailViewController(viewModel: DetailViewModel) -> TeamDetailViewController {
        TeamDetailViewController(viewModel: viewModel)
    }
}
