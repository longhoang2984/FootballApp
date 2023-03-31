//
//  TeamDetailViewController.swift
//  
//
//  Created by Cửu Long Hoàng on 17/03/2023.
//

import UIKit
import Football
import Combine

public final class TeamDetailViewController: BaseViewController {
    private var viewModel: DetailViewModel
    private var cancellables = Set<AnyCancellable>()
    
    public init(viewModel: DetailViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public var onGetData: (() -> Void)?
    
    private(set) public lazy var logoImageView: UIImageView = {
        let imgView = UIImageView()
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.contentMode = .scaleAspectFit
        imgView.clipsToBounds = true
        imgView.isUserInteractionEnabled = true
        return imgView
    }()
    
    private(set) public lazy var previousLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.isUserInteractionEnabled = true
        return lb
    }()
    
    private(set) public lazy var upcomingLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.isUserInteractionEnabled = true
        return lb
    }()
    
    public override func viewDidLoad() {
        setUpLogo()
        super.viewDidLoad()
    }
    
    private func setUpLogo() {
        view.addSubview(logoImageView)
        
        let stackView = UIStackView(arrangedSubviews: [previousLabel, upcomingLabel, UIView()])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .equalCentering
        stackView.spacing = 0
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            logoImageView.widthAnchor.constraint(equalToConstant: 64),
            logoImageView.heightAnchor.constraint(equalToConstant: 64),
            logoImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            
            stackView.leadingAnchor.constraint(equalTo: logoImageView.trailingAnchor, constant: 8),
            stackView.heightAnchor.constraint(equalToConstant: 64),
            view.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: 16),
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
        ])
    }
    
    public override func layoutCollectionView() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 8),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    @objc public override func getData() {
        viewModel.send(.getDatas)
    }
    
    public override func bind() {
        let output = viewModel.transform()
        output
//            .receive(on: DispatchQueue.main)
            .sink { [weak self] ev in
                guard let self = self else { return }
                switch ev {
                case let .displayControllers(controllers):
                    self.display(controllers)
                case let .displayError(error):
                    self.showErrorAlert(error: error)
                case let .displaySelectionTeam(team, image):
                    self.logoImageView.image = image
                    self.title = team.name
                case let .displayMatchesInfo(previous, upcoming):
                    self.previousLabel.text = "Played: \(previous) match(es)"
                    self.upcomingLabel.text = "Upcoming: \(upcoming) match(es)"
                default: break
                }
            }
            .store(in: &cancellables)
    }
}
