//
//  TeamDetailViewController.swift
//  
//
//  Created by Cửu Long Hoàng on 17/03/2023.
//

import UIKit
import Football

public final class TeamDetailViewController: UIViewController {

    private let team: String
    private let image: UIImage?
    
    public init(team: String, image: UIImage?) {
        self.team = team
        self.image = image
        super.init(nibName: nil, bundle: nil)
        setUpUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func setUpUI() {
        view.backgroundColor = .white
        self.title = team
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFit
        imgView.clipsToBounds = true
        imgView.image = image
        imgView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imgView)
        NSLayoutConstraint.activate([
            imgView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            view.trailingAnchor.constraint(equalTo: imgView.trailingAnchor, constant: 10),
            imgView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
}
