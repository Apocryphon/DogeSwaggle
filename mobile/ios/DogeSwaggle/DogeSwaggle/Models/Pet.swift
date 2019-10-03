//
//  Pet.swift
//  DogeSwaggle
//
//  Created by Richard Yeh on 10/2/19.
//  Copyright © 2019 Richard Yeh. All rights reserved.
//

import Foundation

public struct Pet: Codable {
    
    public var petId: String
    
    public var species: String?
    
    public var breed: String?
    
    public var name: String?
}
