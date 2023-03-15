//
//  MainViewController.swift
//  
//
//  Created by Cửu Long Hoàng on 15/03/2023.
//

import UIKit
import Football
import Combine

public final class MainViewController: UIViewController, UICollectionViewDataSourcePrefetching {
    private var viewModel: AppViewModel
    private let input = PassthroughSubject<AppViewModel.Input, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: AppViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let refreshControl = UIRefreshControl()
    private lazy var collectionView: UICollectionView = {
        let fLayout = UICollectionViewFlowLayout()
        let view = UICollectionView(frame: .zero, collectionViewLayout: fLayout)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var teamPickerView: UIPickerView = {
        let view = UIPickerView()
        view.dataSource = self
        view.delegate = self
        return view
    }()
    
    private var selectedTeamName = "All"
    private var teamNames = ["All"]
    private lazy var filterButton: UIButton = {
        let btn = UIButton(type: .custom)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private lazy var dataSource: UICollectionViewDiffableDataSource<Int, CellController> = {
        .init(collectionView: collectionView) { (collectionView, index, controller) in
            controller.dataSource.collectionView(collectionView, cellForItemAt: index)
        }
    }()
    
    public var onRefresh: (() -> Void)?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpFilter()
        refresh()
        bind()
    }
    
    private func setUpFilter() {
        
    }
    
    private func configureCollectionView() {
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        collectionView.refreshControl = refreshControl
        collectionView.dataSource = dataSource
        collectionView.register(ErrorView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: String(describing: ErrorView.self))
    }
    
    @objc private func refresh() {
        onRefresh?()
    }
    
    private func bind() {
        let output = viewModel.transform(input: input.eraseToAnyPublisher())
        output
            .receive(on: DispatchQueue.main)
            .sink { [weak self] ev in
                switch ev {
                case let .getDataSuccess(teams, _):
                    let names = teams.map({ $0.name })
                    self?.teamNames += names
                default: break
                }
            }
            .store(in: &cancellables)
    }
    
    public func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        
    }
    
}

extension MainViewController: UIPickerViewDataSource {
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

extension MainViewController: UIPickerViewDelegate {
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let name = teamNames[row]
    }
}
