//
//  SpaceXLinks.swift
//  WatchAppSharedLogic
//
//  Created by Viktor Jenei on 3/13/18.
//  Copyright © 2018 Viktor Jenei. All rights reserved.
//

import Foundation

public struct SpaceXLinks : Codable {
    var missionPatch : String?
    var videoLink : String?
    
    enum CodingKeys: String, CodingKey {
        case missionPatch = "mission_patch"
        case videoLink = "video_link"
    }
}

extension SpaceXLinks : Equatable {
    public static func ==(lhs: SpaceXLinks, rhs: SpaceXLinks) -> Bool {
        return lhs.missionPatch == rhs.missionPatch && lhs.videoLink == rhs.videoLink
    }
}
