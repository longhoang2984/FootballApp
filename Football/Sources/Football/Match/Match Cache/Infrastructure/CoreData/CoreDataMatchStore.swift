//
//  CoreDataMatchStore.swift
//  
//
//  Created by Cửu Long Hoàng on 15/03/2023.
//

import CoreData

public class CoreDataMatchStore: CoreDataStore {
    private static let modelName = "MatchStore"
    
    public init(storeURL: URL) throws {
        do {
            try super.init(modelName: CoreDataMatchStore.modelName, storeURL: storeURL)
        } catch {
            throw StoreError.failedToLoadPersistentContainer(error)
        }
    }
}
