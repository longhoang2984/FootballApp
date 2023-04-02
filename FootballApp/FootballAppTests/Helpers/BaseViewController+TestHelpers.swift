//
//  BaseViewController+TestHelpers.swift
//  FootballAppTests
//
//  Created by Cửu Long Hoàng on 02/04/2023.
//

import UIKit
import Football
import FootballiOS

extension BaseViewController {
    public override func loadViewIfNeeded() {
        super.loadViewIfNeeded()
        
        collectionView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
    }
    
    var isShowingLoadingIndicator: Bool {
        return loadingIndicator.parent != nil
    }
    
    func numberOfItems(in section: Int) -> Int {
        collectionView.numberOfSections > section ? collectionView.numberOfItems(inSection: section) : 0
    }
    
    func cell(item: Int, section: Int) -> UICollectionViewCell? {
        guard numberOfItems(in: section) > item else {
            return nil
        }
        let ds = collectionView.dataSource
        let index = IndexPath(item: item, section: section)
        return ds?.collectionView(collectionView, cellForItemAt: index)
    }
}

extension BaseViewController {
    
    @discardableResult
    func simulateMatchViewVisible(at index: Int, section: Int) -> MatchCell? {
        return matchView(at: index, section: section) as? MatchCell
    }
    
    @discardableResult
    func simulateMatchBecomingVisibleAgain(at item: Int, section: Int) -> MatchCell? {
        let view = simulateMatchViewNotVisible(at: item, section: section)
        
        let delegate = collectionView.delegate
        let index = IndexPath(item: item, section: section)
        delegate?.collectionView?(collectionView, willDisplay: view!, forItemAt: index)
        
        return view
    }
    
    @discardableResult
    func simulateMatchViewNotVisible(at item: Int, section: Int) -> MatchCell? {
        let view = simulateMatchViewVisible(at: item, section: section)
        
        let delegate = collectionView.delegate
        let index = IndexPath(item: item, section: section)
        delegate?.collectionView?(collectionView, didEndDisplaying: view!, forItemAt: index)
        
        return view
    }
    
    func simulateTapOnHomeTeamName(at item: Int, section: Int) {
        let datasource = collectionView.dataSource
        let index = IndexPath(item: item, section: section)
        let cell = datasource?.collectionView(collectionView, cellForItemAt: index) as? MatchCell
        cell?.selection?(true)
    }
    
    func simulateTapOnAwayTeamName(at item: Int, section: Int) {
        let datasource = collectionView.dataSource
        let index = IndexPath(item: item, section: section)
        let cell = datasource?.collectionView(collectionView, cellForItemAt: index) as? MatchCell
        cell?.selection?(false)
    }
    
    func simulateMatchViewNearVisible(at item: Int, section: Int) {
        let ds = collectionView.prefetchDataSource
        let index = IndexPath(item: item, section: section)
        ds?.collectionView(collectionView, prefetchItemsAt: [index])
    }
    
    func simulateMatchViewNotNearVisible(at item: Int, section: Int) {
        simulateMatchViewNearVisible(at: item, section: section)
        
        let ds = collectionView.prefetchDataSource
        let index = IndexPath(item: item, section: section)
        ds?.collectionView?(collectionView, cancelPrefetchingForItemsAt: [index])
    }
    
    func renderedHomeImageData(at index: Int, section: Int) -> Data? {
        return simulateMatchViewVisible(at: index, section: section)?.renderedHomeImage
    }
    
    func renderedAwayImageData(at index: Int, section: Int) -> Data? {
        return simulateMatchViewVisible(at: index, section: section)?.renderedAwayImage
    }
    
    func numberOfRenderedViews(section: Int) -> Int {
        numberOfItems(in: section)
    }
    
    func matchView(at item: Int, section: Int) -> UICollectionViewCell? {
        cell(item: item, section: section)
    }
    
    private var previousSection: Int { 0 }
    private var upcomingSection: Int { 1 }
}

