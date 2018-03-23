//
//  Launch+Promises.swift
//  WatchAppSharedLogic
//
//  Created by Viktor Jenei on 3/13/18.
//  Copyright © 2018 Viktor Jenei. All rights reserved.
//

import Foundation
import PromiseKit

extension SpaceXLaunch {
    public static func getLatestLaunch(inSession session: URLSession = URLSession.shared) -> Promise<SpaceXLaunch> {
        return Promise { launch in
            let request = URLRequest.latestLaunchRequest()
            let dataTask = session.dataTask(with: request, completionHandler: { (data: Data?, urlResponse: URLResponse?, error: Error?) in
                if let data = data {
                    do {
                        try launch.fulfill(SpaceXLaunch.from(JSONData: data))
                    }
                    catch let e {
                        launch.reject(e)
                    }
                }
                if let error = error {
                    launch.reject(error)
                }
            })
            dataTask.resume()
        }
    }
    
    public static func getUpcomingLaunches(inSession session: URLSession = URLSession.shared) -> Promise<[SpaceXLaunch]> {
        return Promise { launches in
            let request = URLRequest.upcomingLaunchesRequest()
            let dataTask = session.dataTask(with: request, completionHandler: { (data: Data?, urlResponse: URLResponse?, error: Error?) in
                if let data = data {
                    do {
                        try launches.fulfill(SpaceXLaunch.from(JSONData: data))
                    }
                    catch let e {
                        launches.reject(e)
                    }
                }
                if let error = error {
                    launches.reject(error)
                }
            })
            dataTask.resume()
        }
    }
    
}
