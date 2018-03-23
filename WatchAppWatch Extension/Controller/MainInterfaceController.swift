//
//  MainInterfaceController.swift
//  WatchAppWatch Extension
//
//  Created by Viktor Jenei on 2/16/18.
//  Copyright © 2018 Viktor Jenei. All rights reserved.
//

import Foundation
import WatchKit
import WatchConnectivity
import WatchAppSharedLogic_watchOS

final class MainInterfaceController : WKInterfaceController {
    private var menuItems = ["starman", "send simple", "send with reply", "check for launch"]
    
    @IBOutlet var menuTable: WKInterfaceTable!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        print("Main interface Awoke with context")
        self.setupMenuItems()
    }
    
    override func willActivate() {
        super.willActivate()
        
        do {
            try WatchConnectivityService.sharedService.wcSession?.updateApplicationContext(WatchAppState.main.toContextDictionary())
        }
        catch let e {
            print("Sending Context has failed with error: \(e)")
        }
        print("Activating Main Interface Controller")
    }
    
    override func didDeactivate() {
        super.didDeactivate()
        
        print("DeActivating Main Interface Controller")
    }
}

extension MainInterfaceController {
    override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
        if table == menuTable {
            if rowIndex == 0 {
                self.pushController(withName: "starman", context: Optional.none)
            }
            else if rowIndex == 1 {
                self.sendMessgeToIPhone()
            }
            else if rowIndex == 2 {
                self.sendMessgeToIPhone(withCompletion: true)
            }
            else if rowIndex == 3 {
                self.checkForStoredNextLaunch()
            }
        }
    }
}

private extension MainInterfaceController {
    private func setupMenuItems() {
        menuTable.setNumberOfRows(menuItems.count, withRowType: "MenuTableRow")
        
        for i in 0 ..< menuItems.count {
            if let row = menuTable.rowController(at: i) as? MenuTableRow {
                row.titleLabel?.setText(menuItems[i])
            }
        }
    }
}

private extension MainInterfaceController {
    private func sendMessgeToIPhone(withCompletion : Bool = false) {
        if WatchConnectivityService.sharedService.isActive {
            let data = ["dataKey" : "someData"]
            
            if withCompletion {
                WCSession.default.sendMessage(data, replyHandler: { (reply : [String: Any]) in
                    print("Reply received: \(reply)")
                }, errorHandler: { (error: Error) in
                    print("Error received: \(error)")
                })
            }
            else {
                WCSession.default.sendMessage(data, replyHandler: Optional.none, errorHandler: { (error: Error) in
                    print("Error received: \(error)")
                })
            }
        }
        else if !(WatchConnectivityService.sharedService.wcSession?.isReachable ?? false) {
            print("WCSession is not reachable")
        }
        else {
            print("Nor active, nor reachable")
        }
    }
    
    private func checkForStoredNextLaunch() {
        let storedNextLaunch = SpaceXLaunch.fromUserDefaults()
        print("Stored Next Launch Data: \(String(describing: storedNextLaunch))")
        let action = WKAlertAction(title: "ok", style: .cancel) {
            print("ok")
        }
        presentAlert(withTitle: "Next Launch", message: storedNextLaunch != Optional.none ? "Flight num: \(storedNextLaunch!.flightNumber)" : "No Launch", preferredStyle: .alert, actions: [action])
    }
}
