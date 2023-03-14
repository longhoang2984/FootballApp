//
//  TeamLogoDataCache.swift
//  
//
//  Created by Cửu Long Hoàng on 14/03/2023.
//

import Foundation

public protocol TeamLogoDataCache {
    func save(_ data: Data, for url: URL) throws
}
