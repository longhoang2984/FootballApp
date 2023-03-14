//
//  TeamEndpoint.swift
//  
//
//  Created by Cửu Long Hoàng on 14/03/2023.
//

import Foundation

public enum TeamEndpoint {
    case get
    
    public func url(baseURL: URL) -> URL {
        switch self {
        case .get:
            var components = URLComponents()
            components.scheme = baseURL.scheme
            components.host = baseURL.host
            components.path = baseURL.path + "/teams"
            
            return components.url!
        }
    }
}
