//
//  XCTestCase+FailableRetrieveTeamStoreSpecs.swift
//  
//
//  Created by Cửu Long Hoàng on 14/03/2023.
//

import XCTest
import Football

extension FailableRetrieveTeamStoreSpecs where Self: XCTestCase {
    func assertThatRetrieveDeliversFailureOnRetrievalError(on sut: TeamStore, file: StaticString = #filePath, line: UInt = #line) {
        expect(sut, toRetrieve: .failure(anyNSError()), file: file, line: line)
    }
    
    func assertThatRetrieveHasNoSideEffectsOnFailure(on sut: TeamStore, file: StaticString = #filePath, line: UInt = #line) {
        expect(sut, toRetrieveTwice: .failure(anyNSError()), file: file, line: line)
    }
}
