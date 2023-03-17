//
//  CellController.swift
//  
//
//  Created by Cửu Long Hoàng on 15/03/2023.
//

import UIKit

public struct CellController {

    let id: AnyHashable
    let dataSource: UICollectionViewDataSource
    let delegate: UICollectionViewDelegate?
    let dataSourcePrefetching: UICollectionViewDataSourcePrefetching?
    let flowLayoutDelegate: UICollectionViewDelegateFlowLayout?
    
    public init(id: AnyHashable, _ dataSource: UICollectionViewDataSource) {
        self.id = id
        self.dataSource = dataSource
        self.delegate = dataSource as? UICollectionViewDelegate
        self.dataSourcePrefetching = dataSource as? UICollectionViewDataSourcePrefetching
        self.flowLayoutDelegate = dataSource as? UICollectionViewDelegateFlowLayout
    }
}

extension CellController: Equatable {
    public static func == (lhs: CellController, rhs: CellController) -> Bool {
        lhs.id == rhs.id
    }
}

extension CellController: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
