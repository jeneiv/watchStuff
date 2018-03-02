//
//  StarmanInterfaceController.swift
//  WatchAppWatch Extension
//
//  Created by Viktor Jenei on 2/16/18.
//  Copyright © 2018 Viktor Jenei. All rights reserved.
//

import Foundation
import WatchKit
import WatchAppSharedLogic_watchOS

final class StarmanInterfaceController : WKInterfaceController {
    override func willActivate() {
        super.willActivate()
        
        do {
            try WatchConnectivityService.sharedService.wcSession?.updateApplicationContext(WatchAppState.starMan.toContextDictionary())
        }
        catch let e {
            print("Sending Context has failed with error: \(e)")
        }
        print("Activating Main Interface Controller")
    }
}
