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
        viewModel: AppViewModel,
        teamLoader: @escaping () -> AnyPublisher<[Team], Error>,
        matchLoader: @escaping () -> AnyPublisher<[Match], Error>,
        imageLoader: @escaping (URL) -> TeamLogoDataLoader.Publisher,
        awayImageLoader: @escaping (URL) -> TeamLogoDataLoader.Publisher,
        selection: @escaping (DisplayModel) -> Void = { _ in }
    ) -> MainViewController {
        
        let mainVC = makeMainViewController(title: "Matches", viewModel: viewModel)
        let logoAdapter = TeamLogoAdapter(viewModel: viewModel, controller: mainVC, imageLoader: imageLoader,
                                          awayImageLoader: awayImageLoader)
        let adapter = LoadResourcePresentationAdapter(viewModel: viewModel,
                                                      teamLoader: teamLoader,
                                                      matchLoader: matchLoader,
                                                      adapter: logoAdapter)
        
        viewModel.onGetData = adapter.loadResource
        viewModel.filterMatch = adapter.filterMatchWithTeamName
        
        return mainVC
    }
    
    
    
    private static func makeMainViewController(title: String, viewModel: AppViewModel) -> MainViewController {
        MainViewController(viewModel: viewModel)
    }
}


