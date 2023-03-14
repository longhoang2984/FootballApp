//
//  CacheTeamLogoDataUseCaseTests.swift
//  
//
//  Created by Cửu Long Hoàng on 15/03/2023.
//

import XCTest
import Football

final class CacheTeamLogoDataUseCaseTests: XCTestCase {

    func test_init_doesNotMessageStoreUponCreation() {
        let (_, store) = makeSUT()
        
        XCTAssertTrue(store.receivedMessages.isEmpty)
    }
    
    func test_saveImageDataForURL_requestsImageDataInsertionForURL() {
        let (sut, store) = makeSUT()
        let url = anyURL()
        let data = anyData()
        
        try? sut.save(data, for: url)
        
        XCTAssertEqual(store.receivedMessages, [.insert(data: data, for: url)])
    }
    
    func test_saveImageDataFromURL_failsOnStoreInsertionError() {
        let (sut, store) = makeSUT()
        
        expect(sut, toCompleteWith: failed(), when: {
            let insertionError = anyNSError()
            store.completeInsertion(with: insertionError)
        })
    }
    
    func test_saveImageDataFromURL_succeedsOnSuccessfulStoreInsertion() {
        let (sut, store) = makeSUT()
        
        expect(sut, toCompleteWith: .success(()), when: {
            store.completeInsertionSuccessfully()
        })
    }
        
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (sut: LocalTeamLogoDataLoader, store: TeamLogoDataStoreSpy) {
        let store = TeamLogoDataStoreSpy()
        let sut = LocalTeamLogoDataLoader(store: store)
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, store)
    }
    
    private func failed() -> Result<Void, Error> {
        return .failure(LocalTeamLogoDataLoader.SaveError.failed)
    }
    
    private func expect(_ sut: LocalTeamLogoDataLoader, toCompleteWith expectedResult: Result<Void, Error>, when action: () -> Void, file: StaticString = #filePath, line: UInt = #line) {
        action()

        let receivedResult = Result { try sut.save(anyData(), for: anyURL()) }

        switch (receivedResult, expectedResult) {
        case (.success, .success):
            break
            
        case (.failure(let receivedError as LocalTeamLogoDataLoader.SaveError),
              .failure(let expectedError as LocalTeamLogoDataLoader.SaveError)):
            XCTAssertEqual(receivedError, expectedError, file: file, line: line)
            
        default:
            XCTFail("Expected result \(expectedResult), got \(receivedResult) instead", file: file, line: line)
        }
    }

}
