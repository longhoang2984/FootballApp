//
//  XCTestCase+FailableInsertTeamStoreSpecs.swift
//  
//
//  Created by Cửu Long Hoàng on 14/03/2023.
//

import XCTest
import Football

extension FailableInsertTeamStoreSpecs where Self: XCTestCase {
    func assertThatInsertDeliversErrorOnInsertionError(on sut: TeamStore, file: StaticString = #filePath, line: UInt = #line) {
        let insertionError = insert((uniqueTeams().local), to: sut)
        
        XCTAssertNotNil(insertionError, "Expected cache insertion to fail with an error", file: file, line: line)
    }
    
    func assertThatInsertHasNoSideEffectsOnInsertionError(on sut: TeamStore, file: StaticString = #filePath, line: UInt = #line) {
        insert((uniqueTeams().local), to: sut)
        
        expect(sut, toRetrieve: .success(.none), file: file, line: line)
    }
}
