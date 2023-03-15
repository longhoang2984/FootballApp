//
//  File.swift
//  
//
//  Created by Cửu Long Hoàng on 15/03/2023.
//

import CoreData

@objc(ManagedMatch)
class ManagedMatch: NSManagedObject {
    @NSManaged var date: Date
    @NSManaged var matchDescription: String
    @NSManaged var home: String
    @NSManaged var away: String
    @NSManaged var winner: String?
    @NSManaged var highlights: URL?
}

extension ManagedMatch {
    static func images(from localMatches: [LocalMatch], in context: NSManagedObjectContext) -> NSOrderedSet {
        let images = NSOrderedSet(array: localMatches.map { local in
            let managed = ManagedMatch(context: context)
            managed.date = local.date
            managed.matchDescription = local.description
            managed.home = local.home
            managed.away = local.away
            managed.winner = local.winner
            managed.highlights = local.highlights
            return managed
        })
        context.userInfo.removeAllObjects()
        return images
    }
    
    var local: LocalMatch {
        return LocalMatch(date: date,
                          description: matchDescription,
                          home: home,
                          away: away,
                          winner: winner,
                          highlights: highlights)
    }
    
    override func prepareForDeletion() {
        super.prepareForDeletion()
    }
}
