//
//  MatchHeaderView.swift
//  
//
//  Created by Cửu Long Hoàng on 01/04/2023.
//

import UIKit

public final class MatchHeaderView: UICollectionReusableView {
    public enum HeaderType: Int {
        case previous = 0
        case upcoming = 1
    }
    
    private(set) public lazy var nameLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.isUserInteractionEnabled = true
        return lb
    }()
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        setUpUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpUI() {
        backgroundColor = .tertiarySystemBackground
        addSubview(nameLabel)
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 12),
            bottomAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 12),
        ])
    }
}
