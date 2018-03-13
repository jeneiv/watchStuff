//
//  Launch.swift
//  WatchAppSharedLogic
//
//  Created by Viktor Jenei on 3/13/18.
//  Copyright © 2018 Viktor Jenei. All rights reserved.
//

import Foundation

public struct SpaceXLaunch : Codable {
    var flightNumber : Int
    var launchDateUTC : Date
    var rocket : SpaceXRocket
    var launchSite : SpaceXLaunchSite
    var launchSuccess : Bool?
    var links : SpaceXLinks
    
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
    static func from(JSONData data: Data) throws -> SpaceXLaunch {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return try decoder.decode(SpaceXLaunch.self, from: data)
    }

    static func from(JSONData data: Data) throws -> [SpaceXLaunch] {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return try decoder.decode([SpaceXLaunch].self, from: data)
    }
}
