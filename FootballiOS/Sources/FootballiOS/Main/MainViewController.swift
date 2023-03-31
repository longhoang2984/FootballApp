//
//  MainViewController.swift
//  
//
//  Created by Cửu Long Hoàng on 15/03/2023.
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
    
    private let refreshControl = UIRefreshControl()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureCollectionView()
        bind()
        refresh()
    }
    
    private func configureCollectionView() {
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        collectionView.register(MatchCell.self, forCellWithReuseIdentifier: String(describing: MatchCell.self))
        collectionView.register(MatchHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: String(describing: MatchHeaderView.self))
        collectionView.refreshControl = refreshControl
        collectionView.dataSource = dataSource
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
        view.addSubview(collectionView)
        layoutCollectionView()
    }
    
    public func layoutCollectionView() {}
    
    @objc public func refresh() {}
    
    public func bind() {}
    
    func showErrorAlert(error: Error) {
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

public final class MainViewController: BaseViewController {
    private var cancellables = Set<AnyCancellable>()
    
    private let viewModel: AppViewModel
    public init(viewModel: AppViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let refreshControl = UIRefreshControl()
    public var onGetData: (() -> Void)?
    
    private lazy var teamPickerView: UIPickerView = {
        let view = UIPickerView()
        view.dataSource = self
        view.delegate = self
        return view
    }()
    
    private var selectedTeamName = "All"
    private var teamNames = ["All"]
    private lazy var filterField: UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.borderStyle = .roundedRect
        field.text = selectedTeamName
        field.inputView = teamPickerView
        return field
    }()
    
    public var onRefresh: (() -> Void)?
    
    public override func viewDidLoad() {
        setUpFilter()
        super.viewDidLoad()
        self.title = "Matches"
    }
    
    public override func layoutCollectionView() {
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: filterField.bottomAnchor, constant: 8),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    private func setUpFilter() {
        view.addSubview(filterField)
        NSLayoutConstraint.activate([
            filterField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            filterField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            view.trailingAnchor.constraint(equalTo: filterField.trailingAnchor, constant: 8)
        ])
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let filterButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(filterTeamName))
        toolBar.setItems([filterButton], animated: true)
        filterField.inputAccessoryView = toolBar
    }
    
    @objc public override func refresh() {
        viewModel.send(.getDatas)
    }
    
    @objc private func filterTeamName() {
        filterField.resignFirstResponder()
        let name = self.teamNames[self.teamPickerView.selectedRow(inComponent: 0)]
        self.selectedTeamName = name
        self.filterField.text = name
        self.viewModel.send(.filterMatches(teamName: name))
    }
    
    public override func bind() {
        let output = viewModel.transform()
        output
            .receive(on: DispatchQueue.main)
            .sink { [weak self] ev in
                switch ev {
                case let .displayTeamNames(teamNames):
                    self?.teamNames += teamNames
                    break
                case let .displayLoading(loading):
                    loading ? self?.refreshControl.beginRefreshing() : self?.refreshControl.endRefreshing()
                case let .displayControllers(controllers):
                    self?.display(controllers)
                case let .displayError(error):
                    self?.showErrorAlert(error: error)
                default: break
                }
            }
            .store(in: &cancellables)
    }
    
    override func display(_ sections: [[CellController]]) {
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
}

extension MainViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return teamNames.count
    }
    
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return teamNames[row]
    }
    
}
