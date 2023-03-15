//
//  XCTestCase+MatchStoreSpecs.swift
//  
//
//  Created by Cửu Long Hoàng on 15/03/2023.
//

import Foundation
import Football
import XCTest

extension StoreSpecs where Self: XCTestCase {

    func assertThatRetrieveDeliversEmptyOnEmptyCache(on sut: MatchStore, file: StaticString = #filePath, line: UInt = #line) {
        expect(sut, toRetrieve: .success(.none), file: file, line: line)
    }
    
    func assertThatRetrieveHasNoSideEffectsOnEmptyCache(on sut: MatchStore, file: StaticString = #filePath, line: UInt = #line) {
        expect(sut, toRetrieveTwice: .success(.none), file: file, line: line)
    }
    
    func assertThatRetrieveDeliversFoundValuesOnNonEmptyCache(on sut: MatchStore, file: StaticString = #filePath, line: UInt = #line) {
        let matches = uniqueMatches().local
        
        insert((matches), to: sut)
        
        expect(sut, toRetrieve: .success(CachedMatch(matches)), file: file, line: line)
    }
    
    func assertThatRetrieveHasNoSideEffectsOnNonEmptyCache(on sut: MatchStore, file: StaticString = #filePath, line: UInt = #line) {
        let matches = uniqueMatches().local
        
        insert((matches), to: sut)
        
        expect(sut, toRetrieveTwice: .success(CachedMatch(matches)), file: file, line: line)
    }
    
    func assertThatInsertDeliversNoErrorOnEmptyCache(on sut: MatchStore, file: StaticString = #filePath, line: UInt = #line) {
        let insertionError = insert((uniqueMatches().local), to: sut)
        
        XCTAssertNil(insertionError, "Expected to insert cache successfully", file: file, line: line)
    }
    
    func assertThatInsertDeliversNoErrorOnNonEmptyCache(on sut: MatchStore, file: StaticString = #filePath, line: UInt = #line) {
        insert((uniqueMatches().local), to: sut)
        
        let insertionError = insert((uniqueMatches().local), to: sut)
        
        XCTAssertNil(insertionError, "Expected to override cache successfully", file: file, line: line)
    }
    
    func assertThatInsertOverridesPreviouslyInsertedCacheValues(on sut: MatchStore, file: StaticString = #filePath, line: UInt = #line) {
        insert((uniqueMatches().local), to: sut)
        
        let latestMatches = uniqueMatches().local
        insert((latestMatches), to: sut)
        
        expect(sut, toRetrieve: .success(CachedMatch(latestMatches)), file: file, line: line)
    }
    
    func assertThatDeleteDeliversNoErrorOnEmptyCache(on sut: MatchStore, file: StaticString = #filePath, line: UInt = #line) {
        let deletionError = deleteCache(from: sut)
        
        XCTAssertNil(deletionError, "Expected empty cache deletion to succeed", file: file, line: line)
    }
    
    func assertThatDeleteHasNoSideEffectsOnEmptyCache(on sut: MatchStore, file: StaticString = #filePath, line: UInt = #line) {
        deleteCache(from: sut)
        
        expect(sut, toRetrieve: .success(.none), file: file, line: line)
    }
    
    func assertThatDeleteDeliversNoErrorOnNonEmptyCache(on sut: MatchStore, file: StaticString = #filePath, line: UInt = #line) {
        insert((uniqueMatches().local), to: sut)
        
        let deletionError = deleteCache(from: sut)
        
        XCTAssertNil(deletionError, "Expected non-empty cache deletion to succeed", file: file, line: line)
    }
    
    func assertThatDeleteEmptiesPreviouslyInsertedCache(on sut: MatchStore, file: StaticString = #filePath, line: UInt = #line) {
        insert((uniqueMatches().local), to: sut)
        
        deleteCache(from: sut)
        
        expect(sut, toRetrieve: .success(.none), file: file, line: line)
    }

}

extension StoreSpecs where Self: XCTestCase {
    @discardableResult
    func insert(_ cache: ([LocalMatch]), to sut: MatchStore) -> Error? {
        do {
            try sut.insert(cache)
            return nil
        } catch {
            return error
        }
    }
    
    @discardableResult
    func deleteCache(from sut: MatchStore) -> Error? {
        do {
            try sut.deleteCachedMatch()
            return nil
        } catch {
            return error
        }
    }
    
    func expect(_ sut: MatchStore, toRetrieveTwice expectedResult: Result<CachedMatch?, Error>, file: StaticString = #filePath, line: UInt = #line) {
        expect(sut, toRetrieve: expectedResult, file: file, line: line)
        expect(sut, toRetrieve: expectedResult, file: file, line: line)
    }
    
    func expect(_ sut: MatchStore, toRetrieve expectedResult: Result<CachedMatch?, Error>, file: StaticString = #filePath, line: UInt = #line) {
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
