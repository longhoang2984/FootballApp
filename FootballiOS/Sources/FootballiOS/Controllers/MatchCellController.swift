//
//  MatchCellController.swift
//  
//
//  Created by Cửu Long Hoàng on 17/03/2023.
//

import UIKit
import Football
import Combine
import Foundation

public protocol MatchCellControllerDelegate {
    func didRequestImage(url: URL)
    func didCancelImageRequest()
}


public final class MatchCell: UICollectionViewCell {
    private(set) public lazy var homeLogoImageView: UIImageView = {
        let imgView = UIImageView()
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.contentMode = .scaleAspectFit
        imgView.clipsToBounds = true
        return imgView
    }()
    
    private(set) public lazy var homeNameLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()
    
    private(set) public lazy var awayLogoImageView: UIImageView = {
        let imgView = UIImageView()
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.contentMode = .scaleAspectFit
        imgView.clipsToBounds = true
        return imgView
    }()
    
    private(set) public lazy var awayNameLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setUpUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpUI() {
        contentView.addSubview(homeLogoImageView)
        contentView.addSubview(homeNameLabel)
        contentView.addSubview(awayLogoImageView)
        contentView.addSubview(awayNameLabel)
        NSLayoutConstraint.activate([
            homeLogoImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            homeLogoImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            homeLogoImageView.heightAnchor.constraint(equalToConstant: 40),
            homeLogoImageView.widthAnchor.constraint(equalToConstant: 40),
            
            homeNameLabel.leadingAnchor.constraint(equalTo: homeLogoImageView.trailingAnchor, constant: 12),
            homeNameLabel.centerYAnchor.constraint(equalTo: homeLogoImageView.centerYAnchor),
            
            awayLogoImageView.topAnchor.constraint(equalTo: homeLogoImageView.bottomAnchor, constant: 12),
            awayLogoImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            awayLogoImageView.heightAnchor.constraint(equalToConstant: 40),
            awayLogoImageView.widthAnchor.constraint(equalToConstant: 40),
            
            awayNameLabel.leadingAnchor.constraint(equalTo: awayLogoImageView.trailingAnchor, constant: 12),
            awayNameLabel.centerYAnchor.constraint(equalTo: awayLogoImageView.centerYAnchor)
        ])
    }
}

public final class MatchCellController: NSObject {
    public typealias ResourceViewModel = UIImage
    private let model: DisplayModel
    private let selection: () -> Void
    private var cell: MatchCell?
    private let homeDelegate: MatchCellControllerDelegate
    private let awayDelegate: MatchCellControllerDelegate
    public var homeImageViewModel: TeamLogoViewModel<UIImage>?
    public var awayImageViewModel: TeamLogoViewModel<UIImage>?
    private var cancellables = Set<AnyCancellable>()
    public init(model: DisplayModel,
                homeDelegate: MatchCellControllerDelegate,
                awayDelegate: MatchCellControllerDelegate,
                selection: @escaping () -> Void) {
        self.model = model
        self.homeDelegate = homeDelegate
        self.awayDelegate = awayDelegate
        self.selection = selection
    }
    
    public func bind() {
        let output = homeImageViewModel?.transform()
        output?
            .sink(receiveValue: { [weak self] ev in
                switch ev {
                case let .display(model):
                    print(self?.model.homeLogo!.absoluteString)
                    self?.cell?.homeLogoImageView.setImageAnimated(model.image)
                }
            })
            .store(in: &cancellables)
        
        let awayOutput = awayImageViewModel?.transform()
        awayOutput?
            .sink(receiveValue: { [weak self] ev in
                switch ev {
                case let .display(model):
                    print(self?.model.awayLogo!.absoluteString)
                    self?.cell?.awayLogoImageView.setImageAnimated(model.image)
                }
            })
            .store(in: &cancellables)
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
        didRequestImage()
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
        bind()
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

extension MatchCellController: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 150)
    }
}

extension UICollectionView {
    func dequeueReusableCell<T: UICollectionViewCell>(_ indexPath: IndexPath) -> T {
        let identifier = String(describing: T.self)
        return dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! T
    }
}


import UIKit

extension UIImageView {
    func setImageAnimated(_ newImage: UIImage?) {
        image = newImage
        
        guard newImage != nil else { return }
        
        alpha = 0
        UIView.animate(withDuration: 0.25) {
            self.alpha = 1
        }
    }
}
