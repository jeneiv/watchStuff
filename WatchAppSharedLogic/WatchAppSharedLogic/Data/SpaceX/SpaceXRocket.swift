//
//  SpaceXRocket.swift
//  WatchAppSharedLogic
//
//  Created by Viktor Jenei on 3/13/18.
//  Copyright © 2018 Viktor Jenei. All rights reserved.
//

import Foundation

public struct SpaceXRocket : Codable {
    var rocketID : String
    var rocketName : String
    var rocketType : String
    
    enum CodingKeys: String, CodingKey {
        case rocketID = "rocket_id"
        case rocketName = "rocket_name"
        case rocketType = "rocket_type"
    }
}

extension SpaceXRocket : Equatable {
    public static func ==(lhs: SpaceXRocket, rhs: SpaceXRocket) -> Bool {
        return lhs.rocketID == rhs.rocketID && lhs.rocketName == rhs.rocketName && lhs.rocketType == rhs.rocketType
    }
}
