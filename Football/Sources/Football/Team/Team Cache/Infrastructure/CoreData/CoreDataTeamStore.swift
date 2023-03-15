//
//  CoreDataTeamStore.swift
//  
//
//  Created by Cửu Long Hoàng on 14/03/2023.
//

import CoreData

public class CoreDataTeamStore: CoreDataStore {
    private static let modelName = "TeamStore"
    
    public init(storeURL: URL) throws {
        do {
            try super.init(modelName: CoreDataTeamStore.modelName, storeURL: storeURL)
        } catch {
            throw StoreError.failedToLoadPersistentContainer(error)
        }
    }
}
