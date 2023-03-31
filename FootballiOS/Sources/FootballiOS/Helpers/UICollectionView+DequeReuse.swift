//
//  UICollectionView+DequeReuse.swift
//  
//
//  Created by Cửu Long Hoàng on 01/04/2023.
//

import UIKit

extension UICollectionView {
    func dequeueReusableCell<T: UICollectionViewCell>(_ indexPath: IndexPath) -> T {
        let identifier = String(describing: T.self)
        return dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! T
    }
}
