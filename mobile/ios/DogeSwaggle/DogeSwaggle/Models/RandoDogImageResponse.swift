//
//  RandoDogImageResponse.swift
//  DogeSwaggle
//
//  Created by Richard Yeh on 10/3/19.
//  Copyright © 2019 Richard Yeh. All rights reserved.
//

import Foundation

public struct RandoDogImageResponse: Codable {
    
    let dogImageUrls: [String?]
    
    private enum CodingKeys: String, CodingKey {
        
        case dogImageUrls = "message"
    }
    
}
