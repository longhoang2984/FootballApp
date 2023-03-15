//
//  File.swift
//  
//
//  Created by Cửu Long Hoàng on 15/03/2023.
//

import CoreData

@objc(ManagedMatchCache)
class ManagedMatchCache: NSManagedObject {
    @NSManaged var matches: NSOrderedSet
}

extension ManagedMatchCache {
    static func find(in context: NSManagedObjectContext) throws -> ManagedMatchCache? {
        let request = NSFetchRequest<ManagedMatchCache>(entityName: entity().name!)
        request.returnsObjectsAsFaults = false
        return try context.fetch(request).first
    }
    
    static func deleteCache(in context: NSManagedObjectContext) throws {
        try find(in: context).map(context.delete).map(context.save)
    }
    
    static func newUniqueInstance(in context: NSManagedObjectContext) throws -> ManagedMatchCache {
        try deleteCache(in: context)
        return ManagedMatchCache(context: context)
    }
    
    var localMatch: [LocalMatch] {
        return matches.compactMap { ($0 as? ManagedMatch)?.local }
    }
}
