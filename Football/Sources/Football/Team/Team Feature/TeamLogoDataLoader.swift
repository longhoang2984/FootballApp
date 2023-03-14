//
//  TeamLogoDataLoader.swift
//  
//
//  Created by Cửu Long Hoàng on 14/03/2023.
//

import Foundation

public protocol TeamLogoDataLoader {
    func loadImageData(from url: URL) throws -> Data
}
