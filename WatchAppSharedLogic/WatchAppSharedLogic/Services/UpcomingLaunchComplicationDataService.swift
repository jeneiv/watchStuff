//
//  UpcomingLaunchComplicationDataService.swift
//  WatchAppSharedLogic
//
//  Created by Viktor Jenei on 3/21/18.
//  Copyright © 2018 Viktor Jenei. All rights reserved.
//

import Foundation
import WatchConnectivity

final public class UpcomingLaunchComplicationDataService {
    
    public enum ComplicationDataError : Error {
        case WatchSessionInactive
        case InvalidWCSession
        case ComplicationTransferLimitExceeded
        case ComplicationsDisabled
    }
    
    public static func sendComplicationData(forNextLaunch nextLaunch: SpaceXLaunch) throws {
        guard let wcSession = WatchConnectivityService.sharedService.wcSession else {
            throw ComplicationDataError.InvalidWCSession
        }

        guard wcSession.isComplicationEnabled else {
            throw ComplicationDataError.ComplicationsDisabled
        }

        guard WatchConnectivityService.sharedService.isActive else {
            throw ComplicationDataError.WatchSessionInactive
        }
        
        guard wcSession.remainingComplicationUserInfoTransfers > 0 else {
            throw ComplicationDataError.ComplicationTransferLimitExceeded
        }
        
        // Debug
        // var nextLaunch = nextLaunch
        // nextLaunch.launchDateUTC = "2018-04-11T17:32:00Z"

        let launchJSONData = try nextLaunch.toJSONData()
        
        wcSession.transferCurrentComplicationUserInfo([SpaceXLaunch.NextLaunchDataKey : launchJSONData])
        print("UpcomingLaunchComplicationDataService - Complication Data Sent")
    }
}
