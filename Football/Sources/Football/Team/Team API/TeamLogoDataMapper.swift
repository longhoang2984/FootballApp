//
//  TeamLogoDataMapper.swift
//  
//
//  Created by Cửu Long Hoàng on 14/03/2023.
//

import Foundation

public final class TeamLogoDataMapper {
    public enum Error: Swift.Error {
        case invalidData
    }
    
    public static func map(_ data: Data, from response: HTTPURLResponse) throws -> Data {
        guard response.isOK, !data.isEmpty else {
            throw Error.invalidData
        }
        
        return data
    }
}
