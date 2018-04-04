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
    public var launchDate : String
    public var rocket : SpaceXRocket
    public var launchSite : SpaceXLaunchSite
    public var launchSuccess : Bool?
    public var links : SpaceXLinks
    
    enum CodingKeys: String, CodingKey {
        case flightNumber = "flight_number"
        case launchDateUTC = "launch_date_utc"
        case launchDate = "launch_date_local"
        case rocket
        case launchSite = "launch_site"
        case launchSuccess = "launch_success"
        case links
    }
}

extension SpaceXLaunch {
    public static func from(JSONData data: Data) throws -> SpaceXLaunch {
        let decoder = JSONDecoder()
        return try decoder.decode(SpaceXLaunch.self, from: data)
    }

    static func from(JSONData data: Data) throws -> [SpaceXLaunch] {
        let decoder = JSONDecoder()
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

extension SpaceXLaunch {
    public var localLaunchDate : Date? {
        get {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "YYYY-MM-dd'T'HH:mm:ssZ'"
            dateFormatter.timeZone = TimeZone.current
            return dateFormatter.date(from: launchDateUTC)
        }
    }
    
    public var doesLauncheToday : Bool {
        get {
            guard let localLaunchDate = self.localLaunchDate else {
                return false
            }
            return Calendar.current.isDateInToday(localLaunchDate)
        }
    }
    
    public var complicationFillFraction : Float {
        guard let localLaunchDate = self.localLaunchDate else {
            return 0.0
        }
        
        guard doesLauncheToday else {
            return 0.0
        }
        
        let currentDate = Date()
        if currentDate < localLaunchDate {
            let dateDifference = localLaunchDate.timeIntervalSince(currentDate)
            return 1.0 - Float(dateDifference) / 86400.0
        }
        
        return 1.0
    }
    
    public func doesLaunch(atDate date: Date) -> Bool {
        if let localLaunchDate = self.localLaunchDate {
            return Calendar.current.isDate(localLaunchDate, inSameDayAs: date)
        }
        return false
    }
    
    public func complicationFillFraction(atDate date: Date) -> Float {
        guard let localLaunchDate = self.localLaunchDate else {
            return 0.0
        }
        
        guard doesLaunch(atDate: date) else {
            return 0.0
        }

        if date < localLaunchDate {
            let dateDifference = localLaunchDate.timeIntervalSince(date)
            return 1.0 - Float(dateDifference) / 86400.0
        }

        return 1.0
    }
}
