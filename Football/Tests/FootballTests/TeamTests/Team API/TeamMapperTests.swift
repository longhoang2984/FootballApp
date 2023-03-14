//
//  TeamMapperTests.swift
//  
//
//  Created by Cửu Long Hoàng on 14/03/2023.
//

import XCTest
import Football

final class TeamMapperTests: XCTestCase {

    func test_map_throwsErrorOnNon200HTTPResponse() throws {
        let json = makeTeamsJSON([])
        let samples = [199, 201, 300, 400, 500]
        
        try samples.forEach { code in
            XCTAssertThrowsError(
                try TeamMapper.map(json, from: HTTPURLResponse(statusCode: code))
            )
        }
    }
    
    func test_map_throwsErrorOn200HTTPResponseWithInvalidJSON() {
        let invalidJSON = Data("invalid json".utf8)
        
        XCTAssertThrowsError(
            try TeamMapper.map(invalidJSON, from: HTTPURLResponse(statusCode: 200))
        )
    }
    
    func test_map_deliversNoTeamsOn200HTTPResponseWithEmptyJSONList() throws {
        let emptyListJSON = makeTeamsJSON([])
        
        let result = try TeamMapper.map(emptyListJSON, from: HTTPURLResponse(statusCode: 200))
        
        XCTAssertEqual(result, [])
    }
    
    func test_map_deliversTeamsOn200HTTPResponseWithJSONItems() throws {
        let item1 = makeItem(
            id: UUID(),
            name: "Team A",
            logo: URL(string: "http://a-url.com")!)
        
        let item2 = makeItem(
            id: UUID(),
            name: "Team B",
            logo: URL(string: "http://b-url.com")!)
        
        let json = makeTeamsJSON([item1.json, item2.json])
        
        let result = try TeamMapper.map(json, from: HTTPURLResponse(statusCode: 200))
        
        XCTAssertEqual(result, [item1.model, item2.model])
    }
    
    // MARK: - Helpers
    
    private func makeItem(id: UUID, name: String, logo: URL) -> (model: Team, json: [String: Any]) {
        let item = Team(id: id, name: name, logo: logo)
        
        let json = [
            "id": id.uuidString,
            "name": name,
            "logo": logo.absoluteString
        ].compactMapValues { $0 }
        
        return (item, json)
    }
    

}
