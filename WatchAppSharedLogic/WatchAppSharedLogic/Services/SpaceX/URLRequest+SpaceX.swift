//
//  URLRequest+SpaceX.swift
//  WatchAppSharedLogic
//
//  Created by Viktor Jenei on 3/13/18.
//  Copyright © 2018 Viktor Jenei. All rights reserved.
//

import Foundation

// API Doc:
// https://github.com/r-spacex/SpaceX-API/wiki

extension URLRequest {
    private static let SpaceXAPIHost = "api.spacexdata.com"
    
    private enum SpaceXEndpoint : String {
        case latest = "/v2/launches/latest"
        case all = "/v2/launches/all"
        case upcoming = "/v2/launches/upcoming"
        case pastLaunches = "v2/launches"
    }
    
    static func upcomingLaunchesRequest() -> URLRequest {
        let URLString = "https://" + URLRequest.SpaceXAPIHost + SpaceXEndpoint.upcoming.rawValue
        let url = URL(string: URLString)!
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        return request
    }
    
    static func latestLaunchRequest() -> URLRequest {
        let URLString = "https://" + URLRequest.SpaceXAPIHost + SpaceXEndpoint.latest.rawValue
        let url = URL(string: URLString)!
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        return request
    }
}
