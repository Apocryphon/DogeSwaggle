//
//  Park.swift
//  DogeSwaggle
//
//  Created by Richard Yeh on 10/3/19.
//  Copyright © 2019 Richard Yeh. All rights reserved.
//

import Foundation

public struct Park: Decodable {
    
    public var id: String
    public var address: String
    public var latitude: String
    public var longitude: String
    public var name: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case data
        case address
        case latitude
        case longitude
        case name
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        
        let data = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .data)
        
        address = try data.decode(String.self, forKey: .address)
        latitude = try data.decode(String.self, forKey: .latitude)
        longitude = try data.decode(String.self, forKey: .longitude)
        name = try data.decode(String.self, forKey: .name)
    }
}
