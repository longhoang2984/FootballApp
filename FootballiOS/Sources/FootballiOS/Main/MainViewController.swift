//
//  MainViewController.swift
//  
//
//  Created by Cửu Long Hoàng on 15/03/2023.
//

import UIKit
import Football
import Combine

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
    
    @objc public override func getData() {
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
            .sink { [weak self] ev in
                switch ev {
                case let .displayTeamNames(teamNames):
                    self?.teamNames += teamNames
                    break
                case let .displayLoading(loading):
                    loading ? self?.startLoading() : self?.endLoading()
                case let .displayControllers(controllers):
                    self?.display(controllers)
                case let .displayError(error):
                    self?.showErrorAlert(error: error)
                default: break
                }
            }
            .store(in: &viewModel.cancellables)
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        title = "Matches"
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        title = ""
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
