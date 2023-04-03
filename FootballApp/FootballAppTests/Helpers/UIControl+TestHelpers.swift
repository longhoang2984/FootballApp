//
//  UIControl+TestHelpers.swift
//  FootballAppTests
//
//  Created by Cửu Long Hoàng on 03/04/2023.
//

import UIKit

extension UIControl {
    func simulate(event: UIControl.Event) {
        allTargets.forEach { target in
            actions(forTarget: target, forControlEvent: event)?.forEach {
                (target as NSObject).perform(Selector($0))
            }
        }
    }
}
