//
//  SpaceXLaunch.swift
//  WatchAppSharedLogic
//
//  Created by Viktor Jenei on 3/13/18.
//  Copyright © 2018 Viktor Jenei. All rights reserved.
//

import Foundation

public struct SpaceXLaunch : Codable {
    public var flightNumber : Int
    public var launchDateUTC : String
    public var rocket : SpaceXRocket
    public var launchSite : SpaceXLaunchSite
    public var launchSuccess : Bool?
    public var links : SpaceXLinks
    
    enum CodingKeys: String, CodingKey {
        case flightNumber = "flight_number"
        case launchDateUTC = "launch_date_utc"
        case rocket
        case launchSite = "launch_site"
        case launchSuccess = "launch_success"
        case links
    }
}

extension SpaceXLaunch {
    public static func from(JSONData data: Data) throws -> SpaceXLaunch {
        let decoder = JSONDecoder()
        // decoder.dateDecodingStrategy = .iso8601
        return try decoder.decode(SpaceXLaunch.self, from: data)
    }

    static func from(JSONData data: Data) throws -> [SpaceXLaunch] {
        let decoder = JSONDecoder()
        // decoder.dateDecodingStrategy = .iso8601
        return try decoder.decode([SpaceXLaunch].self, from: data)
    }
    
    public func toJSONData() throws -> Data {
        let encoder = JSONEncoder()
        let JSONData = try encoder.encode(self)
        return JSONData
    }
}

extension SpaceXLaunch : Equatable {
    public static func ==(lhs: SpaceXLaunch, rhs: SpaceXLaunch) -> Bool {
        return lhs.flightNumber == rhs.flightNumber && lhs.launchDateUTC == rhs.launchDateUTC && lhs.rocket == rhs.rocket && lhs.launchSite == rhs.launchSite && lhs.launchSuccess == rhs.launchSuccess && lhs.links == rhs.links
    }
}

