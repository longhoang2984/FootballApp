//
//  TeamStoreSpy.swift
//  
//
//  Created by Cửu Long Hoàng on 14/03/2023.
//

import Foundation
import Football

class TeamStoreSpy: TeamStore {
    enum ReceivedMessage: Equatable {
        case deleteCachedTeam
        case insert([LocalTeam])
        case retrieve
    }
    
    private(set) var receivedMessages = [ReceivedMessage]()
    
    private var deletionResult: Result<Void, Error>?
    private var insertionResult: Result<Void, Error>?
    private var retrievalResult: Result<CachedTeam?, Error>?
    
    func deleteCachedTeam() throws {
        receivedMessages.append(.deleteCachedTeam)
        try deletionResult?.get()
    }
    
    func completeDeletion(with error: Error) {
        deletionResult = .failure(error)
    }
    
    func completeDeletionSuccessfully() {
        deletionResult = .success(())
    }
    
    func insert(_ teams: [LocalTeam]) throws {
        receivedMessages.append(.insert(teams))
        try insertionResult?.get()
    }
    
    func completeInsertion(with error: Error) {
        insertionResult = .failure(error)
    }
    
    func completeInsertionSuccessfully() {
        insertionResult = .success(())
    }
    
    func retrieve() throws -> CachedTeam? {
        receivedMessages.append(.retrieve)
        return try retrievalResult?.get()
    }
    
    func completeRetrieval(with error: Error) {
        retrievalResult = .failure(error)
    }
    
    func completeRetrievalWithEmptyCache() {
        retrievalResult = .success(.none)
    }
    
    func completeRetrieval(with teams: [LocalTeam]) {
        retrievalResult = .success(CachedTeam(teams))
    }
}
