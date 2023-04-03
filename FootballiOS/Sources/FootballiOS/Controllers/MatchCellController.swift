//
//  MatchCellController.swift
//  
//
//  Created by Cửu Long Hoàng on 17/03/2023.
//

import UIKit
import Football
import Foundation

public final class MatchCellController: NSObject {
    public typealias Img = UIImage
    
    private let model: DisplayModel
    private let selection: (_ team: String, _ image: UIImage?) -> Void
    private let onShowHighlight: () -> Void
    private var cell: MatchCell?
    private let homeDelegate: MatchCellControllerDelegate
    private let awayDelegate: MatchCellControllerDelegate
    public init(model: DisplayModel,
                homeDelegate: MatchCellControllerDelegate,
                awayDelegate: MatchCellControllerDelegate,
                selection: @escaping (_ team: String, _ image: UIImage?) -> Void,
                onShowHighlight: @escaping () -> Void) {
        self.model = model
        self.homeDelegate = homeDelegate
        self.awayDelegate = awayDelegate
        self.selection = selection
        self.onShowHighlight = onShowHighlight
    }
}

extension MatchCellController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDataSourcePrefetching {
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        1
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        cell = collectionView.dequeueReusableCell(indexPath)
        cell?.homeNameLabel.text = model.home
        cell?.homeLogoImageView.image = nil
        cell?.awayLogoImageView.image = nil
        cell?.awayNameLabel.text = model.away
        cell?.dateLabel.text = model.date
        cell?.timeLabel.text = model.time
        cell?.highlightButton.isHidden = model.highlights == nil
        cell?.awayWinnerImageView.isHidden = model.winner != model.away
        cell?.homeWinnerImageView.isHidden = model.winner != model.home
        cell?.homeImageContainer.isShimmering = true
        cell?.awayImageContainer.isShimmering = true
        
        didRequestImage()
        cell?.onShowHighlight = onShowHighlight
        cell?.selection = { [weak self] isHome in
            guard let self = self else { return }
            let img = isHome ? self.cell?.homeLogoImageView.image : self.cell?.awayLogoImageView.image
            let name = isHome ? self.model.home : self.model.away
            self.selection(name, img)
        }
        
        return cell!
    }
    
    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        self.cell = cell as? MatchCell
        didRequestImage()
    }
    
    public func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cancelLoad()
    }
    
    public func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        didRequestImage()
    }
    
    public func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        cancelLoad()
    }
    
    private func cancelLoad() {
        releaseCellForReuse()
        didCancelImageRequest()
    }
    
    private func releaseCellForReuse() {
        cell = nil
    }
    
    private func didRequestImage() {
        if let url = model.homeLogo {
            homeDelegate.didRequestImage(url: url)
        }
        
        if let url = model.awayLogo {
            awayDelegate.didRequestImage(url: url)
        }
    }
    
    private func didCancelImageRequest() {
        homeDelegate.didCancelImageRequest()
        awayDelegate.didCancelImageRequest()
    }
}

extension MatchCellController: TeamLogoView {
    public func display(_ model: TeamLogoModel<UIImage>) {
        if self.model.homeLogo == model.url {
            cell?.homeImageContainer.isShimmering = model.isLoading
            if model.image != nil {
                cell?.homeLogoImageView.image = model.image
            }
        } else {
            cell?.awayImageContainer.isShimmering = model.isLoading
            if model.image != nil {
                cell?.awayLogoImageView.image = model.image
            }
        }
    }
}

extension MatchCellController: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 120)
    }
}
