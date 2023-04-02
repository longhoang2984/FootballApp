//
//  MainUIComposer.swift
//  FootballApp
//
//  Created by Cửu Long Hoàng on 16/03/2023.
//

import UIKit
import Combine
import Football
import FootballiOS

public final class MainUIComposer {
    private init() {}
    
    
    public static func mainComposedWith(
        teamLoader: @escaping () -> AnyPublisher<[Team], Error>,
        matchLoader: @escaping () -> AnyPublisher<[Match], Error>,
        imageLoader: @escaping (URL) -> TeamLogoDataLoader.Publisher,
        awayImageLoader: @escaping (URL) -> TeamLogoDataLoader.Publisher,
        selection: @escaping (_ team: Team, _ image: UIImage?) -> Void = { _, _ in }
    ) -> MainViewController {
        
        let input = PassthroughSubject<AppViewModel.Input, Never>()
        let output = PassthroughSubject<AppViewModel.Output, Never>()
        let viewModel = AppViewModel(input: input, output: output)
        
        let mainVC = makeMainViewController(title: "Matches", viewModel: viewModel)
        let logoAdapter = TeamLogoAdapter(imageLoader: imageLoader,
                                          awayImageLoader: awayImageLoader,
                                          selection: selection)
       
        let adapter = LoadResourcePresentationAdapter(teamLoader: teamLoader,
                                                      matchLoader: matchLoader,
                                                      onLoading: { input.send(.showLoading($0)) },
                                                      onError: { input.send(.showError($0)) },
                                                      onShowTeams: { input.send(.showTeams($0)) },
                                                      onShowData: { input.send(.showControllers(controllers: logoAdapter.handleSuccessData(teams: $0, matches: $1))) })
    
        viewModel.onGetData = adapter.loadResource
        viewModel.filterMatch = adapter.filterMatchWithTeamName
        
        return mainVC
    }
    
    private static func makeMainViewController(title: String, viewModel: AppViewModel) -> MainViewController {
        MainViewController(viewModel: viewModel)
    }
}


