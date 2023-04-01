//
//  TeamLogoLoaderAdapter.swift
//  FootballApp
//
//  Created by Cửu Long Hoàng on 01/04/2023.
//

import Foundation
import Football
import FootballiOS
import Combine

final class TeamLogoLoaderAdapter<View: TeamLogoView, Image>: MatchCellControllerDelegate where View.Img == Image {
    
    private let imageLoader: (URL) -> TeamLogoDataLoader.Publisher
    private var cancellable: AnyCancellable?
    private var isLoading = false
    
    var viewModel: TeamLogoViewModel<View, Image>?
    
    init(imageLoader: @escaping (URL) -> TeamLogoDataLoader.Publisher) {
        self.imageLoader = imageLoader
    }
    
    func didCancelImageRequest() {
        cancellable?.cancel()
        cancellable = nil
    }
    
    func didRequestImage(url: URL) {
        guard !isLoading else { return }
        viewModel?.didStartLoadingImageData(url: url)
        
        cancellable = imageLoader(url)
            .dispatchOnMainQueue()
            .handleEvents(receiveCancel: { [weak self] in
                self?.isLoading = false
            })
            .sink { [weak self] completion in
                switch completion {
                case .finished: break
                case let .failure(error):
                    self?.viewModel?.didFinishLoadingImageData(with: error, url: url)
                }
                self?.isLoading = false
            } receiveValue: { [weak self] data in
                self?.viewModel?.didFinishLoadingImageData(with: data, url: url)
            }
        
    }
}
