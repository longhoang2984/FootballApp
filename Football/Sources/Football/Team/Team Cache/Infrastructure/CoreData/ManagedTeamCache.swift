//
//  ManagedTeamCache.swift
//  
//
//  Created by Cửu Long Hoàng on 14/03/2023.
//

import CoreData

@objc(ManagedTeamCache)
class ManagedTeamCache: NSManagedObject {
    @NSManaged var teams: NSOrderedSet
}

extension ManagedTeamCache {
    static func find(in context: NSManagedObjectContext) throws -> ManagedTeamCache? {
        let request = NSFetchRequest<ManagedTeamCache>(entityName: entity().name!)
        request.returnsObjectsAsFaults = false
        return try context.fetch(request).first
    }
    
    static func deleteCache(in context: NSManagedObjectContext) throws {
        try find(in: context).map(context.delete).map(context.save)
    }
    
    static func newUniqueInstance(in context: NSManagedObjectContext) throws -> ManagedTeamCache {
        try deleteCache(in: context)
        return ManagedTeamCache(context: context)
    }
    
    var localTeam: [LocalTeam] {
        return teams.compactMap { ($0 as? ManagedTeam)?.local }
    }
}

