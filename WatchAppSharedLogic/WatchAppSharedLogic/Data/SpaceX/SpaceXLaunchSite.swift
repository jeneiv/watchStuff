//
//  SpaceXLaunchSite.swift
//  WatchAppSharedLogic
//
//  Created by Viktor Jenei on 3/13/18.
//  Copyright © 2018 Viktor Jenei. All rights reserved.
//

import Foundation

public struct SpaceXLaunchSite : Codable {
    var siteID : String
    var siteName : String
    var siteLongName : String
    
    enum CodingKeys: String, CodingKey {
        case siteID = "site_id"
        case siteName = "site_name"
        case siteLongName = "site_name_long"
    }
}

extension SpaceXLaunchSite : Equatable {
    public static func ==(lhs: SpaceXLaunchSite, rhs: SpaceXLaunchSite) -> Bool {
        return lhs.siteID == rhs.siteID && lhs.siteName == rhs.siteName && lhs.siteLongName == rhs.siteLongName
    }
}
