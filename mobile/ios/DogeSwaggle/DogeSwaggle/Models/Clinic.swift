//
//  Clinic.swift
//  DogeSwaggle
//
//  Created by Richard Yeh on 10/4/19.
//  Copyright © 2019 Richard Yeh. All rights reserved.
//

import Foundation

public struct Clinic: Decodable {
    
    public var id: String
    public var location: String
    public var state: String
    public var address: String
    public var latitude: String
    public var longitude: String

    enum CodingKeys: String, CodingKey {
        case id
        case data
        case location
        case state
        case address
        case latitude
        case longitude
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        
        let data = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .data)
        
        location = try data.decode(String.self, forKey: .location)
        state = try data.decode(String.self, forKey: .state)
        address = try data.decode(String.self, forKey: .address)
        latitude = try data.decode(String.self, forKey: .latitude)
        longitude = try data.decode(String.self, forKey: .longitude)
    }
}

