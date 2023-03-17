//
//  TeamLogoAdapter.swift
//  FootballApp
//
//  Created by Cửu Long Hoàng on 16/03/2023.
//

import UIKit
import Football
import FootballiOS
import Combine
import AVKit

final class TeamLogoLoaderAdapter<Img>: MatchCellControllerDelegate {
    
    private let imageLoader: (URL) -> TeamLogoDataLoader.Publisher
    private var cancellables = Set<AnyCancellable>()
    
    var viewModel: TeamLogoViewModel<Img>?
    
    init(imageLoader: @escaping (URL) -> TeamLogoDataLoader.Publisher) {
        self.imageLoader = imageLoader
        
    }
    
    func didCancelImageRequest() {
        viewModel?.input.send(.cancelImage)
        cancellables.forEach({ $0.cancel() })
    }
    
    func didRequestImage(url: URL) {
        viewModel?.input.send(.requestImage)
       
        imageLoader(url)
            .dispatchOnMainQueue()
            .sink { [weak self] completion in
                switch completion {
                case .finished: break
                case let .failure(error):
                    self?.viewModel?.input.send(.showError(error))
                }
            } receiveValue: { [weak self] data in
                self?.viewModel?.input.send(.showImageData(data))
            }
            .store(in: &cancellables)
            
    }
}

final class TeamLogoAdapter {
    private weak var controller: MainViewController?
    private let imageLoader: (URL) -> TeamLogoDataLoader.Publisher
    private let awayImageLoader: (URL) -> TeamLogoDataLoader.Publisher

    private typealias TeamLogoViewModelAdapter = TeamLogoLoaderAdapter<UIImage>
    private var cancellables = Set<AnyCancellable>()
    private let viewModel: DisplayViewModel
    init(viewModel: DisplayViewModel,
         controller: MainViewController,
        imageLoader: @escaping (URL) -> TeamLogoDataLoader.Publisher,
        awayImageLoader: @escaping (URL) -> TeamLogoDataLoader.Publisher) {
        self.viewModel = viewModel
        self.imageLoader = imageLoader
        self.awayImageLoader = awayImageLoader
        self.controller = controller
    }
    
    func handleSuccessData(teams: [Team], matches: [Match]) {
        let cellControllers = matches.map { match in
            let home = teams.first(where: { $0.name == match.home })
            let homeAdapter = TeamLogoViewModelAdapter(imageLoader: { [imageLoader] url in
                imageLoader(url)
            })
            
            let homeLogoVM = TeamLogoViewModel<UIImage>(mapper: UIImage.tryMake)
            homeAdapter.viewModel = homeLogoVM
            
            let away = teams.first(where: { $0.name == match.away })
            let awayAdapter = TeamLogoViewModelAdapter(imageLoader: { [awayImageLoader] url in
                awayImageLoader(url)
            })
            let awayLogoVM = TeamLogoViewModel<UIImage>(mapper: UIImage.tryMake)
            awayAdapter.viewModel = awayLogoVM
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM"
            let date = dateFormatter.string(from: match.date)
            
            dateFormatter.dateFormat = "HH:mm"
            let time = dateFormatter.string(from: match.date)
            let displayModel = DisplayModel(date: date, time: time,
                                            description: match.description, home: match.home,
                                            away: match.away, homeLogo: home?.logo, awayLogo: away?.logo,
                                            winner: match.winner, highlights: match.highlights)
            
            let view = MatchCellController(model: displayModel,
                                           homeDelegate: homeAdapter,
                                           awayDelegate: awayAdapter,
                                           selection: { [weak self] team, img in
                self?.showTeamDetail(teamName: team, img: img)
            },
                                           onShowHighlight: { [weak self] in
                self?.playHighlight(url: match.highlights)
            })
            view.homeImageViewModel = homeLogoVM
            
            view.awayImageViewModel = awayLogoVM
            
            let controller = CellController(id: "\(home?.id.uuidString ?? "")\(away?.id.uuidString ?? "")\(date)\(time)", view)
            return controller
        }
        
        viewModel.send(.showControllers(controllers: cellControllers))
    }
    
    private func playHighlight(url: URL?) {
        guard let url = url else { return }
        let videoURL = URL(string: url.absoluteString)
        let player = AVPlayer(url: videoURL!)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        controller?.present(playerViewController, animated: true) {
            playerViewController.player!.play()
        }
    }
    
    private func showTeamDetail(teamName: String, img: UIImage?) {
        let detailVC = TeamDetailViewController(team: teamName, image: img)
        controller?.navigationController?.pushViewController(detailVC, animated: true)
    }
}

extension UIImage {
    struct InvalidImageData: Error {}

    static func tryMake(data: Data) throws -> UIImage {
        guard let image = UIImage(data: data) else {
            throw InvalidImageData()
        }

        return image
    }
}
