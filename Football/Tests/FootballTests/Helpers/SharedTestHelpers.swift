//
//  SharedTestHelpers.swift
//  
//
//  Created by Cửu Long Hoàng on 14/03/2023.
//

import Foundation

func anyNSError() -> NSError {
    return NSError(domain: "any error", code: 0)
}

func anyURL() -> URL {
    return URL(string: "http://any-url.com")!
}

func anyData() -> Data {
    return Data("any data".utf8)
}

func makeTeamsJSON(_ teams: [[String: Any]]) -> Data {
    let json = ["teams": teams]
    return try! JSONSerialization.data(withJSONObject: json)
}

func makeMatchesJSON(previousMatches: [[String: Any]], upcomingMatches: [[String: Any]]) -> Data {
    let json = ["matches": [
        "previous": previousMatches,
        "upcoming": upcomingMatches
    ]]
    return try! JSONSerialization.data(withJSONObject: json)
}

extension HTTPURLResponse {
    convenience init(statusCode: Int) {
        self.init(url: anyURL(), statusCode: statusCode, httpVersion: nil, headerFields: nil)!
    }
}

extension Date {
    func adding(days: Int, calendar: Calendar = Calendar(identifier: .gregorian)) -> Date {
        return calendar.date(byAdding: .day, value: days, to: self)!
    }
}
