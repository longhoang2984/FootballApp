//
//  MatchCell.swift
//  
//
//  Created by Cửu Long Hoàng on 01/04/2023.
//

import UIKit

public protocol MatchCellControllerDelegate {
    func didRequestImage(url: URL)
    func didCancelImageRequest()
}

public final class MatchCell: UICollectionViewCell {
    
    public var onShowHighlight: (() -> Void)?
    public var selection: ((_ isHome: Bool) -> Void)?
    
    private(set) public lazy var homeImageContainer: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.clipsToBounds = true
        v.layer.cornerRadius = 20
        v.backgroundColor = .secondarySystemBackground
        return v
    }()
    
    private(set) public lazy var homeLogoImageView: UIImageView = {
        let imgView = UIImageView()
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.contentMode = .scaleAspectFit
        imgView.clipsToBounds = true
        imgView.isUserInteractionEnabled = true
        return imgView
    }()
    
    private(set) public lazy var homeNameLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.isUserInteractionEnabled = true
        return lb
    }()
    
    private(set) public lazy var awayImageContainer: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.clipsToBounds = true
        v.layer.cornerRadius = 20
        v.backgroundColor = .secondarySystemBackground
        return v
    }()
    
    private(set) public lazy var awayLogoImageView: UIImageView = {
        let imgView = UIImageView()
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.contentMode = .scaleAspectFit
        imgView.clipsToBounds = true
        imgView.isUserInteractionEnabled = true
        return imgView
    }()
    
    private(set) public lazy var awayNameLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.isUserInteractionEnabled = true
        return lb
    }()
    
    private(set) public lazy var dateLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.textAlignment = .center
        return lb
    }()
    
    private(set) public lazy var timeLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.textAlignment = .center
        return lb
    }()
    
    private(set) public lazy var highlightButton: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(systemName: "play.laptopcomputer")?.withRenderingMode(.alwaysTemplate), for: .normal)
        btn.setTitle("Highlight", for: .normal)
        btn.setTitleColor(.tintColor, for: .normal)
        btn.tintColor = .tintColor
        btn.titleLabel?.font = .systemFont(ofSize: 12)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(onHighlightAction), for: .touchUpInside)
        return btn
    }()
    
    private(set) public lazy var homeWinnerImageView: UIImageView = {
        let imgView = UIImageView()
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.contentMode = .scaleAspectFit
        imgView.clipsToBounds = true
        imgView.image = UIImage(systemName: "trophy.fill")?.withRenderingMode(.alwaysTemplate)
        imgView.tintColor = .yellow
        return imgView
    }()
   
    private(set) public lazy var awayWinnerImageView: UIImageView = {
        let imgView = UIImageView()
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.contentMode = .scaleAspectFit
        imgView.clipsToBounds = true
        imgView.image = UIImage(systemName: "trophy.fill")?.withRenderingMode(.alwaysTemplate)
        imgView.tintColor = .yellow
        return imgView
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setUpUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpUI() {
        contentView.addSubview(homeImageContainer)
        contentView.addSubview(homeNameLabel)
        homeImageContainer.addSubview(homeLogoImageView)
        
        contentView.addSubview(awayImageContainer)
        contentView.addSubview(awayNameLabel)
        awayImageContainer.addSubview(awayLogoImageView)
        
        let wrapperView = UIView()
        wrapperView.translatesAutoresizingMaskIntoConstraints = false
        wrapperView.addSubview(dateLabel)
        wrapperView.addSubview(timeLabel)
        wrapperView.addSubview(highlightButton)
        
        contentView.addSubview(wrapperView)
        
        let lineView = UIView()
        lineView.translatesAutoresizingMaskIntoConstraints = false
        lineView.backgroundColor = .lightGray
        contentView.addSubview(lineView)
        
        let horLineView = UIView()
        horLineView.translatesAutoresizingMaskIntoConstraints = false
        horLineView.backgroundColor = .lightGray
        contentView.addSubview(horLineView)
        
        contentView.addSubview(homeWinnerImageView)
        contentView.addSubview(awayWinnerImageView)
        
        NSLayoutConstraint.activate([
            homeImageContainer.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            homeImageContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            homeImageContainer.heightAnchor.constraint(equalToConstant: 40),
            homeImageContainer.widthAnchor.constraint(equalToConstant: 40),
            
            homeLogoImageView.topAnchor.constraint(equalTo: homeImageContainer.topAnchor),
            homeLogoImageView.leadingAnchor.constraint(equalTo: homeImageContainer.leadingAnchor),
            homeLogoImageView.trailingAnchor.constraint(equalTo: homeImageContainer.trailingAnchor),
            homeLogoImageView.bottomAnchor.constraint(equalTo: homeImageContainer.bottomAnchor),
            
            homeNameLabel.leadingAnchor.constraint(equalTo: homeImageContainer.trailingAnchor, constant: 4),
            homeNameLabel.centerYAnchor.constraint(equalTo: homeImageContainer.centerYAnchor),
            
            awayImageContainer.topAnchor.constraint(equalTo: homeLogoImageView.bottomAnchor, constant: 12),
            awayImageContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            awayImageContainer.heightAnchor.constraint(equalToConstant: 40),
            awayImageContainer.widthAnchor.constraint(equalToConstant: 40),
            
            awayLogoImageView.topAnchor.constraint(equalTo: awayImageContainer.topAnchor),
            awayLogoImageView.leadingAnchor.constraint(equalTo: awayImageContainer.leadingAnchor),
            awayLogoImageView.trailingAnchor.constraint(equalTo: awayImageContainer.trailingAnchor),
            awayLogoImageView.bottomAnchor.constraint(equalTo: awayImageContainer.bottomAnchor),
            
            awayNameLabel.leadingAnchor.constraint(equalTo: awayImageContainer.trailingAnchor, constant: 4),
            awayNameLabel.centerYAnchor.constraint(equalTo: awayImageContainer.centerYAnchor),
            
            contentView.trailingAnchor.constraint(equalTo: wrapperView.trailingAnchor),
            wrapperView.topAnchor.constraint(equalTo: contentView.topAnchor),
            wrapperView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            wrapperView.widthAnchor.constraint(equalToConstant: 100),
            
            dateLabel.topAnchor.constraint(equalTo: wrapperView.topAnchor, constant: 24),
            dateLabel.leadingAnchor.constraint(equalTo: wrapperView.leadingAnchor, constant: 12),
            wrapperView.trailingAnchor.constraint(equalTo: dateLabel.trailingAnchor, constant: 12),
            
            timeLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor),
            timeLabel.leadingAnchor.constraint(equalTo: wrapperView.leadingAnchor, constant: 12),
            wrapperView.trailingAnchor.constraint(equalTo: timeLabel.trailingAnchor, constant: 12),
            
            highlightButton.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 8),
            highlightButton.leadingAnchor.constraint(equalTo: wrapperView.leadingAnchor),
            wrapperView.trailingAnchor.constraint(equalTo: highlightButton.trailingAnchor),
            
            lineView.trailingAnchor.constraint(equalTo: wrapperView.leadingAnchor),
            lineView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            contentView.bottomAnchor.constraint(equalTo: lineView.bottomAnchor, constant: 12),
            lineView.widthAnchor.constraint(equalToConstant: 1),
            
            horLineView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            contentView.trailingAnchor.constraint(equalTo: horLineView.trailingAnchor, constant: 12),
            horLineView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            horLineView.heightAnchor.constraint(equalToConstant: 1),
            
            lineView.leadingAnchor.constraint(greaterThanOrEqualTo: homeNameLabel.trailingAnchor, constant: 8),
            
            homeWinnerImageView.centerYAnchor.constraint(equalTo: homeLogoImageView.centerYAnchor),
            lineView.trailingAnchor.constraint(equalTo: homeWinnerImageView.trailingAnchor, constant: 4),
            
            awayWinnerImageView.centerYAnchor.constraint(equalTo: awayLogoImageView.centerYAnchor),
            lineView.trailingAnchor.constraint(equalTo: awayWinnerImageView.trailingAnchor, constant: 4),
        ])
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(selectHomeTeam))
        homeNameLabel.addGestureRecognizer(gesture)
        
        let homeImgGesture = UITapGestureRecognizer(target: self, action: #selector(selectHomeTeam))
        homeLogoImageView.addGestureRecognizer(homeImgGesture)
        
        let awayGesture = UITapGestureRecognizer(target: self, action: #selector(selectAwayTeam))
        awayNameLabel.addGestureRecognizer(awayGesture)
        
        let awayImgGesture = UITapGestureRecognizer(target: self, action: #selector(selectHomeTeam))
        awayLogoImageView.addGestureRecognizer(awayImgGesture)
    }
    
    @objc func onHighlightAction() {
        onShowHighlight?()
    }
    
    @objc func selectHomeTeam() {
        selection?(true)
    }
    
    @objc func selectAwayTeam() {
        selection?(false)
    }
}
