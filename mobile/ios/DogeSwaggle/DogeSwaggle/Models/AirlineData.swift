//
//  AirlineArrival.swift
//  DogeSwaggle
//
//  Created by Aaron Jubbal on 10/4/19.
//  Copyright © 2019 Richard Yeh. All rights reserved.
//

import UIKit

public struct AirlineData: Decodable {
//    public var arrivals: String
    
    public var airportCode: String
    public var date: String
    public var time: String
    public var airportName: String
    
    enum CodingKeys: String, CodingKey {
        case Arrival
        case Date
        case Time
        case AirportName
        case AirportCode
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let arrival = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .Arrival)
        
        date = try arrival.decode(String.self, forKey: .Date)
        time = try arrival.decode(String.self, forKey: .Time)
        airportName = try arrival.decode(String.self, forKey: .AirportName)
        airportCode = try arrival.decode(String.self, forKey: .AirportCode)
    }
}

//public struct AirlineArrival: Decodable {
//
//    public var airportCode: String
//    public var date: String
//    public var time: String
//    public var airportName: String
//
//    enum CodingKeys: String, CodingKey {
//        case id
//        case data
//        case address
//        case latitude
//        case longitude
//        case name
//    }
//
//    public init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        id = try container.decode(String.self, forKey: .id)
//
//        let data = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .data)
//
//        address = try data.decode(String.self, forKey: .address)
//        latitude = try data.decode(String.self, forKey: .latitude)
//        longitude = try data.decode(String.self, forKey: .longitude)
//        name = try data.decode(String.self, forKey: .name)
//    }
//
//}
