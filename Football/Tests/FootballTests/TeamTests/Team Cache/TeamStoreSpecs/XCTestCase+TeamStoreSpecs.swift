//
// XCTestCase+TeamStoreSpecs.swift
//  
//
//  Created by Cửu Long Hoàng on 14/03/2023.
//

import XCTest
import Football

extension StoreSpecs where Self: XCTestCase {

    func assertThatRetrieveDeliversEmptyOnEmptyCache(on sut: TeamStore, file: StaticString = #filePath, line: UInt = #line) {
        expect(sut, toRetrieve: .success(.none), file: file, line: line)
    }
    
    func assertThatRetrieveHasNoSideEffectsOnEmptyCache(on sut: TeamStore, file: StaticString = #filePath, line: UInt = #line) {
        expect(sut, toRetrieveTwice: .success(.none), file: file, line: line)
    }
    
    func assertThatRetrieveDeliversFoundValuesOnNonEmptyCache(on sut: TeamStore, file: StaticString = #filePath, line: UInt = #line) {
        let teams = uniqueTeams().local
        
        insert((teams), to: sut)
        
        expect(sut, toRetrieve: .success(CachedTeam(teams)), file: file, line: line)
    }
    
    func assertThatRetrieveHasNoSideEffectsOnNonEmptyCache(on sut: TeamStore, file: StaticString = #filePath, line: UInt = #line) {
        let teams = uniqueTeams().local
        
        insert((teams), to: sut)
        
        expect(sut, toRetrieveTwice: .success(CachedTeam(teams)), file: file, line: line)
    }
    
    func assertThatInsertDeliversNoErrorOnEmptyCache(on sut: TeamStore, file: StaticString = #filePath, line: UInt = #line) {
        let insertionError = insert((uniqueTeams().local), to: sut)
        
        XCTAssertNil(insertionError, "Expected to insert cache successfully", file: file, line: line)
    }
    
    func assertThatInsertDeliversNoErrorOnNonEmptyCache(on sut: TeamStore, file: StaticString = #filePath, line: UInt = #line) {
        insert((uniqueTeams().local), to: sut)
        
        let insertionError = insert((uniqueTeams().local), to: sut)
        
        XCTAssertNil(insertionError, "Expected to override cache successfully", file: file, line: line)
    }
    
    func assertThatInsertOverridesPreviouslyInsertedCacheValues(on sut: TeamStore, file: StaticString = #filePath, line: UInt = #line) {
        insert((uniqueTeams().local), to: sut)
        
        let latestTeams = uniqueTeams().local
        insert((latestTeams), to: sut)
        
        expect(sut, toRetrieve: .success(CachedTeam(latestTeams)), file: file, line: line)
    }
    
    func assertThatDeleteDeliversNoErrorOnEmptyCache(on sut: TeamStore, file: StaticString = #filePath, line: UInt = #line) {
        let deletionError = deleteCache(from: sut)
        
        XCTAssertNil(deletionError, "Expected empty cache deletion to succeed", file: file, line: line)
    }
    
    func assertThatDeleteHasNoSideEffectsOnEmptyCache(on sut: TeamStore, file: StaticString = #filePath, line: UInt = #line) {
        deleteCache(from: sut)
        
        expect(sut, toRetrieve: .success(.none), file: file, line: line)
    }
    
    func assertThatDeleteDeliversNoErrorOnNonEmptyCache(on sut: TeamStore, file: StaticString = #filePath, line: UInt = #line) {
        insert((uniqueTeams().local), to: sut)
        
        let deletionError = deleteCache(from: sut)
        
        XCTAssertNil(deletionError, "Expected non-empty cache deletion to succeed", file: file, line: line)
    }
    
    func assertThatDeleteEmptiesPreviouslyInsertedCache(on sut: TeamStore, file: StaticString = #filePath, line: UInt = #line) {
        insert((uniqueTeams().local), to: sut)
        
        deleteCache(from: sut)
        
        expect(sut, toRetrieve: .success(.none), file: file, line: line)
    }

}

extension StoreSpecs where Self: XCTestCase {
    @discardableResult
    func insert(_ cache: ([LocalTeam]), to sut: TeamStore) -> Error? {
        do {
            try sut.insert(cache)
            return nil
        } catch {
            return error
        }
    }
    
    @discardableResult
    func deleteCache(from sut: TeamStore) -> Error? {
        do {
            try sut.deleteCachedTeam()
            return nil
        } catch {
            return error
        }
    }
    
    func expect(_ sut: TeamStore, toRetrieveTwice expectedResult: Result<CachedTeam?, Error>, file: StaticString = #filePath, line: UInt = #line) {
        expect(sut, toRetrieve: expectedResult, file: file, line: line)
        expect(sut, toRetrieve: expectedResult, file: file, line: line)
    }
    
    func expect(_ sut: TeamStore, toRetrieve expectedResult: Result<CachedTeam?, Error>, file: StaticString = #filePath, line: UInt = #line) {
        let retrievedResult = Result { try sut.retrieve() }
        
        switch (expectedResult, retrievedResult) {
        case (.success(.none), .success(.none)),
             (.failure, .failure):
            break
            
        case let (.success(.some(expected)), .success(.some(retrieved))):
            XCTAssertEqual(retrieved, expected, file: file, line: line)
            
        default:
            XCTFail("Expected to retrieve \(expectedResult), got \(retrievedResult) instead", file: file, line: line)
        }
    }
}
