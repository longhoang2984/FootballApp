//
//  XCTestCase+FailableInsertMatchStoreSpecs.swift
//  
//
//  Created by Cửu Long Hoàng on 15/03/2023.
//

import XCTest
import Football

extension FailableInsertStoreSpecs where Self: XCTestCase {
    func assertThatInsertDeliversErrorOnInsertionError(on sut: MatchStore, file: StaticString = #filePath, line: UInt = #line) {
        let insertionError = insert((uniqueMatches().local), to: sut)
        
        XCTAssertNotNil(insertionError, "Expected cache insertion to fail with an error", file: file, line: line)
    }
    
    func assertThatInsertHasNoSideEffectsOnInsertionError(on sut: MatchStore, file: StaticString = #filePath, line: UInt = #line) {
        insert((uniqueMatches().local), to: sut)
        
        expect(sut, toRetrieve: .success(.none), file: file, line: line)
    }
}
