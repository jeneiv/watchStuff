//
//  FetchNextLaunchBackgroundTask.swift
//  WatchApp
//
//  Created by Viktor Jenei on 3/23/18.
//  Copyright © 2018 Viktor Jenei. All rights reserved.
//

import Foundation
import UIKit
import WatchAppSharedLogic
import PromiseKit

class FetchNextLaunchBackgroundTask {
    static func fetchNextLaunch() -> Promise<UIBackgroundFetchResult> {
        return Promise { fetchResult in
            SpaceXLaunch.getUpcomingLaunches().done({ (result : [SpaceXLaunch]) in
                if let nextLaunch = result.first {
                    let storedNextLaunch = SpaceXLaunch.fromUserDefaults()
                    if storedNextLaunch == Optional.none || nextLaunch != storedNextLaunch {
                        
                        do {
                            try UpcomingLaunchComplicationDataService.sendComplicationData(forNextLaunch: nextLaunch)
                            nextLaunch.saveToUserDefaults()
                        }
                        catch let e {
                            print("AppDelegate - Error Sending Complication Data to watch: \(e)")
                            WatchConnectivityService.sharedService.pendingComplicationData = nextLaunch
                        }
                        
                        print("Background Fetch -> New data")
                        fetchResult.fulfill(.newData)
                    }
                    else {
                        print("Background Fetch -> No data")
                        fetchResult.fulfill(.noData)
                    }
                }
                else {
                    print("Background Fetch -> No data")
                    fetchResult.fulfill(.noData)
                }
            })
            .catch({ (error : Error) in
                fetchResult.fulfill(.failed)
            })
        }
    }
}
