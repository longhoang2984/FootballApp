//
//  HTTPURLResponse+StatusCode.swift
//  
//
//  Created by Cửu Long Hoàng on 14/03/2023.
//

import Foundation

extension HTTPURLResponse {
    private static var OK_200: Int { return 200 }
    
    var isOK: Bool {
        return statusCode == HTTPURLResponse.OK_200
    }
}
