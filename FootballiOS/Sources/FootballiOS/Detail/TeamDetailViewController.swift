//
//  TeamDetailViewController.swift
//  
//
//  Created by Cửu Long Hoàng on 17/03/2023.
//

import UIKit
import Football
import Combine

public final class TeamDetailViewController: UICollectionViewController, UICollectionViewDataSourcePrefetching {
    private var viewModel: AppViewModel
    private var cancellables = Set<AnyCancellable>()
    
    public init(viewModel: AppViewModel) {
        self.viewModel = viewModel
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public var onGetData: (() -> Void)?
    
    private lazy var dataSource: UICollectionViewDiffableDataSource<Int, CellController> = {
        .init(collectionView: collectionView) { (collectionView, index, controller) in
            controller.dataSource.collectionView(collectionView, cellForItemAt: index)
        }
    }()
    
    public var onRefresh: (() -> Void)?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Matches"
        configureCollectionView()
        bind()
        getData()
    }
    
    private func configureCollectionView() {
        collectionView.register(MatchCell.self, forCellWithReuseIdentifier: String(describing: MatchCell.self))
        collectionView.dataSource = dataSource
        collectionView.contentInset.top = 50
    }
    
    @objc private func getData() {
        viewModel.send(.getDatas)
    }
    
    public func bind() {
        let output = viewModel.transform()
        output
            .receive(on: DispatchQueue.main)
            .sink { [weak self] ev in
                guard let self = self else { return }
                switch ev {
                case let .displayControllers(controllers):
                    self.display(controllers)
                case let .displayError(error):
                    self.showErrorAlert(error: error)
                default: break
                }
            }
            .store(in: &cancellables)
    }
    
    private func showErrorAlert(error: Error) {
        let vc = UIAlertController(title: "Oops!", message: error.localizedDescription, preferredStyle: .alert)
        let okBtn = UIAlertAction(title: "OK", style: .cancel)
        vc.addAction(okBtn)
        present(vc, animated: true)
    }
    
    func display(_ sections: [[CellController]]) {
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
    
    public override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let dl = cellController(at: indexPath)?.delegate
        dl?.collectionView?(collectionView, didSelectItemAt: indexPath)
    }
    
    public override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let dl = cellController(at: indexPath)?.delegate
        dl?.collectionView?(collectionView, willDisplay: cell, forItemAt: indexPath)
    }
    
    public override func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
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

extension TeamDetailViewController: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let dl = cellController(at: indexPath)?.flowLayoutDelegate
        return dl?.collectionView?(collectionView, layout: collectionViewLayout, sizeForItemAt: indexPath) ?? .zero
    }
}
