//
//  UIButton+TestHelpers.swift
//  FootballAppTests
//
//  Created by Cửu Long Hoàng on 03/04/2023.
//

import UIKit

extension UIButton {
    func simulateTap() {
        simulate(event: .touchUpInside)
    }
}
