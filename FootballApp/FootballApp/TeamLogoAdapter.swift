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

final class TeamLogoAdapter {
    
    private weak var controller: UIViewController?
    private let imageLoader: (URL) -> TeamLogoDataLoader.Publisher
    private let awayImageLoader: (URL) -> TeamLogoDataLoader.Publisher
    
    private typealias TeamLogoViewModelAdapter = TeamLogoLoaderAdapter<WeakRefVirtualProxy<MatchCellController>, UIImage>
    
    private let selection: (_ team: Team, _ image: UIImage?) -> Void
    private let onShowMatchesInfo: (_ previous: Int, _ upcoming: Int) -> Void
    init(controller: UIViewController,
         imageLoader: @escaping (URL) -> TeamLogoDataLoader.Publisher,
         awayImageLoader: @escaping (URL) -> TeamLogoDataLoader.Publisher,
         selection: @escaping (_ team: Team, _ image: UIImage?) -> Void,
         onShowMatchesInfo: @escaping (_ previous: Int, _ upcoming: Int) -> Void = { _, _ in }) {
        self.imageLoader = imageLoader
        self.awayImageLoader = awayImageLoader
        self.controller = controller
        self.selection = selection
        self.onShowMatchesInfo = onShowMatchesInfo
    }
    
    func handleSuccessData(teams: [Team], matches: [Match]) -> [[CellController]] {
        var previousControllers = [CellController]()
        var upcomingControllers = [CellController]()
        matches.forEach { match in
            let home = teams.first(where: { $0.name == match.home })
            let homeAdapter = TeamLogoViewModelAdapter(imageLoader: { [imageLoader] url in
                imageLoader(url)
            })
            
            let away = teams.first(where: { $0.name == match.away })
            let awayAdapter = TeamLogoViewModelAdapter(imageLoader: { [awayImageLoader] url in
                awayImageLoader(url)
            })
            
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
                if let team = teams.first(where: { $0.name == team }) {
                    self?.selection(team, img)
                }
            },
                                           onShowHighlight: { [weak self] in
                self?.playHighlight(url: match.highlights)
            })
            
            let homeLogoVM = TeamLogoViewModel(view: WeakRefVirtualProxy(view),
                                               mapper: UIImage.tryMake)
            homeAdapter.viewModel = homeLogoVM
            
            let awayLogoVM = TeamLogoViewModel(view: WeakRefVirtualProxy(view),
                                               mapper: UIImage.tryMake)
            awayAdapter.viewModel = awayLogoVM
            
            let controller = CellController(id: "\(home?.id.uuidString ?? "")\(away?.id.uuidString ?? "")\(date)\(time)", view)
            if match.winner == nil {
                upcomingControllers.append(controller)
            } else {
                previousControllers.append(controller)
            }
        }
        
        onShowMatchesInfo(previousControllers.count, upcomingControllers.count)
        return [previousControllers, upcomingControllers]
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

final class WeakRefVirtualProxy<T: AnyObject> {
    private weak var object: T?
    
    init(_ object: T) {
        self.object = object
    }
}

extension WeakRefVirtualProxy: TeamLogoView where T: TeamLogoView, T.Img == UIImage {
    func display(_ model: TeamLogoModel<UIImage>) {
        object?.display(model)
    }
}
