//
//  LaunchInterfaceController.swift
//  WatchAppWatch Extension
//
//  Created by Viktor Jenei on 3/29/18.
//  Copyright © 2018 Viktor Jenei. All rights reserved.
//

import Foundation
import WatchKit
import WatchAppSharedLogic_watchOS

final class LaunchInterfaceController : WKInterfaceController {
    @IBOutlet weak var flightNumberLabel : WKInterfaceLabel!
    @IBOutlet weak var dateLabel : WKInterfaceLabel!

    override func willActivate() {
        super.willActivate()
        
        do {
            try WatchConnectivityService.sharedService.wcSession?.updateApplicationContext(WatchAppState.launch.toContextDictionary())
        }
        catch let e {
            print("Sending Context has failed with error: \(e)")
        }
        
        if let nextLaunch = SpaceXLaunch.fromUserDefaults() {
            flightNumberLabel.setText(" " + String(nextLaunch.flightNumber))
            
            if let localLaunchDate = nextLaunch.localLaunchDate {
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd HH:mm"
                let dateStr = formatter.string(from: localLaunchDate)
                dateLabel.setText(" " + dateStr)
            }
        }
    }

}
