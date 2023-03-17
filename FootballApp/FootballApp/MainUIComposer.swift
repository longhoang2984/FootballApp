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
        viewModel: DisplayViewModel,
        teamLoader: @escaping () -> AnyPublisher<[Team], Error>,
        matchLoader: @escaping () -> AnyPublisher<[Match], Error>,
        imageLoader: @escaping (URL) -> TeamLogoDataLoader.Publisher,
        awayImageLoader: @escaping (URL) -> TeamLogoDataLoader.Publisher,
        selection: @escaping (DisplayModel) -> Void = { _ in }
    ) -> MainViewController {
        let logoAdapter = TeamLogoAdapter(viewModel: viewModel, imageLoader: imageLoader,
                                          awayImageLoader: awayImageLoader)
        let adapter = LoadResourcePresentationAdapter(viewModel: viewModel,
                                                      teamLoader: teamLoader,
                                                      matchLoader: matchLoader,
                                                      adapter: logoAdapter)
        
        
        let mainVC = makeMainViewController(title: "Matches", viewModel: viewModel)
        viewModel.onGetData = adapter.loadResource
        
        return mainVC
    }
    
    
    
    private static func makeMainViewController(title: String, viewModel: DisplayViewModel) -> MainViewController {
        let vc = MainViewController(viewModel: viewModel)
        vc.title = title
        return vc
    }
}


