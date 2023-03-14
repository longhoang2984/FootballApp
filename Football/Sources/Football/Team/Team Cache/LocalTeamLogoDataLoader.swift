//
//  LocalTeamLogoDataLoader.swift
//  
//
//  Created by Cửu Long Hoàng on 14/03/2023.
//

import Foundation

public final class LocalTeamLogoDataLoader {
    private let store: TeamLogoDataStore
    
    public init(store: TeamLogoDataStore) {
        self.store = store
    }
}

extension LocalTeamLogoDataLoader: TeamLogoDataCache {
    public enum SaveError: Error {
        case failed
    }
    
    public func save(_ data: Data, for url: URL) throws {
        do {
            try store.insert(data, for: url)
        } catch {
            throw SaveError.failed
        }
    }
}

extension LocalTeamLogoDataLoader: TeamLogoDataLoader {
    public enum LoadError: Error {
        case failed
        case notFound
    }
        
    public func loadImageData(from url: URL) throws -> Data {
        do {
            if let imageData = try store.retrieve(dataForURL: url) {
                return imageData
            }
        } catch {
            throw LoadError.failed
        }
        
        throw LoadError.notFound
    }
}

