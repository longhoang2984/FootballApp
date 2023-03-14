//
//  TeamLogoDataStore.swift
//  
//
//  Created by Cửu Long Hoàng on 14/03/2023.
//

import Foundation

public protocol TeamLogoDataStore {
    func insert(_ data: Data, for url: URL) throws
    func retrieve(dataForURL url: URL) throws -> Data?
}
