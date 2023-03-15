//
//  XCTestCase+FailableRetrieveMatchStoreSpecs.swift
//  
//
//  Created by Cửu Long Hoàng on 15/03/2023.
//

import XCTest
import Football

extension FailableRetrieveStoreSpecs where Self: XCTestCase {
    func assertThatRetrieveDeliversFailureOnRetrievalError(on sut: MatchStore, file: StaticString = #filePath, line: UInt = #line) {
        expect(sut, toRetrieve: .failure(anyNSError()), file: file, line: line)
    }
    
    func assertThatRetrieveHasNoSideEffectsOnFailure(on sut: MatchStore, file: StaticString = #filePath, line: UInt = #line) {
        expect(sut, toRetrieveTwice: .failure(anyNSError()), file: file, line: line)
    }
}
