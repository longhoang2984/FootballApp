//
//  MatchEndpointTests.swift
//  
//
//  Created by Cửu Long Hoàng on 15/03/2023.
//

import XCTest
import Football

final class MatchEndpointTests: XCTestCase {

    func test_team_endpointURL() {
        let baseURL = URL(string: "http://base-url.com")!
        
        let received = MatchEndpoint.get.url(baseURL: baseURL)
        
        XCTAssertEqual(received.scheme, "http", "scheme")
        XCTAssertEqual(received.host, "base-url.com", "host")
        XCTAssertEqual(received.path, "/teams/matches", "path")
    }


}
