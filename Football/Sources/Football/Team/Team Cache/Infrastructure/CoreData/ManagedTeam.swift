//
//  File.swift
//  
//
//  Created by Cửu Long Hoàng on 14/03/2023.
//

import CoreData

@objc(ManagedTeam)
class ManagedTeam: NSManagedObject {
    @NSManaged var id: UUID
    @NSManaged var name: String
    @NSManaged var logo: URL
    @NSManaged var data: Data?
}

extension ManagedTeam {
    static func data(with url: URL, in context: NSManagedObjectContext) throws -> Data? {
        if let data = context.userInfo[url] as? Data { return data }
        
        return try first(with: url, in: context)?.data
    }
    
    static func first(with url: URL, in context: NSManagedObjectContext) throws -> ManagedTeam? {
        let request = NSFetchRequest<ManagedTeam>(entityName: entity().name!)
        request.predicate = NSPredicate(format: "%K = %@", argumentArray: [#keyPath(ManagedTeam.logo), url])
        request.returnsObjectsAsFaults = false
        request.shouldRefreshRefetchedObjects = false
        request.fetchLimit = 1
        return try context.fetch(request).first
    }
    
    static func images(from localTeams: [LocalTeam], in context: NSManagedObjectContext) -> NSOrderedSet {
        let images = NSOrderedSet(array: localTeams.map { local in
            let managed = ManagedTeam(context: context)
            managed.id = local.id
            managed.name = local.name
            managed.logo = local.logo
            managed.data = context.userInfo[local.logo] as? Data
            return managed
        })
        context.userInfo.removeAllObjects()
        return images
    }
    
    var local: LocalTeam {
        return LocalTeam(id: id, name: name, logo: logo)
    }
    
    override func prepareForDeletion() {
        super.prepareForDeletion()
        
        managedObjectContext?.userInfo[logo] = data
    }
}
