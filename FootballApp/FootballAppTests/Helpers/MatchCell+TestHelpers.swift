//
//  MatchCell+TestHelpers.swift
//  FootballAppTests
//
//  Created by Cửu Long Hoàng on 02/04/2023.
//

import UIKit
import FootballiOS

extension MatchCell {
    var isShowingHomeImageLoadingIndicator: Bool {
        return homeImageContainer.isShimmering
    }
    
    var isShowingAwayImageLoadingIndicator: Bool {
        return awayImageContainer.isShimmering
    }
    
    var homeText: String? {
        return homeNameLabel.text
    }
    
    var awayText: String? {
        return awayNameLabel.text
    }
    
    var dateText: String? {
        return dateLabel.text
    }
    
    var timeText: String? {
        return timeLabel.text
    }
    
    var renderedHomeImage: Data? {
        return homeLogoImageView.image?.pngData()
    }
    
    var renderedAwayImage: Data? {
        return awayLogoImageView.image?.pngData()
    }
}
