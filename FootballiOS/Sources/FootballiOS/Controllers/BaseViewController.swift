//
//  BaseViewController.swift
//  
//
//  Created by Cửu Long Hoàng on 01/04/2023.
//

import UIKit
import Football
import Combine

public class BaseViewController: UIViewController {
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    lazy var dataSource: UICollectionViewDiffableDataSource<Int, CellController> = {
        let ds = UICollectionViewDiffableDataSource<Int, CellController>(collectionView: collectionView) { (collectionView, index, controller) in
            controller.dataSource.collectionView(collectionView, cellForItemAt: index)
        }
        
        ds.supplementaryViewProvider = { (collectionView, kind, index) -> UICollectionReusableView? in
            self.collectionView(collectionView, viewForSupplementaryElementOfKind: kind, at: index)
        }
        
        return ds
        
    }()
    
    private let loadingIndicator = LoadingIndicator()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureCollectionView()
        bind()
        getData()
    }
    
    private func configureCollectionView() {
        collectionView.register(MatchCell.self, forCellWithReuseIdentifier: String(describing: MatchCell.self))
        collectionView.register(MatchHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: String(describing: MatchHeaderView.self))
        collectionView.bounces = true
        collectionView.dataSource = dataSource
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
        view.addSubview(collectionView)
        layoutCollectionView()
    }
    
    public func layoutCollectionView() {}
    
    @objc public func getData() {}
    
    public func bind() {}
    
    func showErrorAlert(error: Error) {
        let vc = UIAlertController(title: "Oops!", message: error.localizedDescription, preferredStyle: .alert)
        let okBtn = UIAlertAction(title: "OK", style: .cancel)
        vc.addAction(okBtn)
        present(vc, animated: true)
    }
    
    public func display(_ sections: [[CellController]]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, CellController>()
        sections.enumerated().forEach { section, cellControllers in
            snapshot.appendSections([section])
            snapshot.appendItems(cellControllers, toSection: section)
        }
        
        if #available(iOS 15.0, *) {
            dataSource.applySnapshotUsingReloadData(snapshot)
        } else {
            dataSource.apply(snapshot)
        }
    }
    
    func startLoading() {
        addChild(loadingIndicator)
        loadingIndicator.view.frame = view.frame
        view.addSubview(loadingIndicator.view)
        loadingIndicator.didMove(toParent: self)
        loadingIndicator.willMove(toParent: nil)
    }
    
    func endLoading() {
        loadingIndicator.view.removeFromSuperview()
        loadingIndicator.removeFromParent()
    }
}

extension BaseViewController: UICollectionViewDataSourcePrefetching {
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let dl = cellController(at: indexPath)?.delegate
        dl?.collectionView?(collectionView, didSelectItemAt: indexPath)
    }
    
    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let dl = cellController(at: indexPath)?.delegate
        dl?.collectionView?(collectionView, willDisplay: cell, forItemAt: indexPath)
    }
    
    public func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let dl = cellController(at: indexPath)?.delegate
        dl?.collectionView?(collectionView, didEndDisplaying: cell, forItemAt: indexPath)
    }
    
    public func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { indexPath in
            let dsp = cellController(at: indexPath)?.dataSourcePrefetching
            dsp?.collectionView(collectionView, prefetchItemsAt: [indexPath])
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { indexPath in
            let dsp = cellController(at: indexPath)?.dataSourcePrefetching
            dsp?.collectionView?(collectionView, cancelPrefetchingForItemsAt: [indexPath])
        }
    }
    
    private func cellController(at indexPath: IndexPath) -> CellController? {
        dataSource.itemIdentifier(for: indexPath)
    }
}

extension BaseViewController: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let dl = cellController(at: indexPath)?.flowLayoutDelegate
        return dl?.collectionView?(collectionView, layout: collectionViewLayout, sizeForItemAt: indexPath) ?? .zero
    }
    
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: String(describing: MatchHeaderView.self), for: indexPath) as! MatchHeaderView
            let type = MatchHeaderView.HeaderType(rawValue: indexPath.section)
            view.nameLabel.text = (type == .previous ? "Previous" : "Upcoming").uppercased()
            return view
        default:
            return UICollectionReusableView()
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return dataSource.numberOfSections(in: collectionView) > 0 ? .init(width: collectionView.bounds.width, height: 50) : .zero
    }
}

class LoadingIndicator: UIViewController {
    var spinner = UIActivityIndicatorView(style: .large)
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .secondarySystemBackground
        
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.startAnimating()
        view.addSubview(spinner)
        
        spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
}
