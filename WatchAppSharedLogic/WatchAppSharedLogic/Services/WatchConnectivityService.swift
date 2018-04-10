//
//  WatchConnectivityService.swift
//  WatchApp
//
//  Created by Viktor Jenei on 2/19/18.
//  Copyright © 2018 Viktor Jenei. All rights reserved.
//

import Foundation
import WatchConnectivity
#if os(watchOS)
    import ClockKit
#endif

public final class WatchConnectivityService : NSObject {
    public static let sharedService = WatchConnectivityService()

    private static let PendingComplicationDataUserDefaultsKey = "PendingComplicationDataUserDefaultsKey"
    private (set) public var wcSession : WCSession?
    private (set) public var isActive = false {
        didSet {
            print("New WatchConnectivityService.isActive state: \(isActive)")
        }
    }
    
    #if os(iOS)
    public var pendingComplicationData : SpaceXLaunch? {
        get {
            return SpaceXLaunch.fromUserDefaults(withKey: WatchConnectivityService.PendingComplicationDataUserDefaultsKey)
        }
        set (newComplicationData) {
            if let newData = newComplicationData {
                newData.saveToUserDefaults(withKey: WatchConnectivityService.PendingComplicationDataUserDefaultsKey)
            }
            else {
                UserDefaults.standard.removeObject(forKey: WatchConnectivityService.PendingComplicationDataUserDefaultsKey)
            }
        }
    }
    #endif
    
    private override init() {
        if WCSession.isSupported() {
            print("WCsession is supportted")
            
            wcSession = WCSession.default
            
            super.init()
            
            WCSession.default.delegate = self
            WCSession.default.activate()
        }
        else {
            super.init()
            print("WCsession is NOT supportted")
        }
    }
}

// MARK: - WCSSessionDelegate

extension WatchConnectivityService : WCSessionDelegate {

    // MARK: iOS Only Methods
    
    #if os(iOS)
    
    public func sessionDidBecomeInactive(_ session: WCSession) {
        print("WatchConnectivityService -> sessionDidBecomeInactive")
        isActive = false
    }
    
    public func sessionDidDeactivate(_ session: WCSession) {
        print("WatchConnectivityService -> sessionDidDeactivate")
        isActive = false
    }
    
    private func trySendingPendingComplicationData(_ complicationData: SpaceXLaunch) {
        do {
            try UpcomingLaunchComplicationDataService.sendComplicationData(forNextLaunch: complicationData)
            self.pendingComplicationData = Optional.none
        }
        catch let e {
            print("WatchConnectivityService - Error Sending Complication Data to watch: \(e)")
        }
    }
    
    #endif

    // MARK: State handling
    
    public func session(_ session: WCSession, didReceiveUserInfo userInfo: [String : Any] = [:]) {
        print("WatchConnectivityService -> didReceiveUserInfo: \(userInfo)")
        #if os(watchOS)
        if let nextLaunchData = userInfo[SpaceXLaunch.NextLaunchDataKey] as? Data {
            do {
                let nextLaunch : SpaceXLaunch = try SpaceXLaunch.from(JSONData: nextLaunchData)
                nextLaunch.saveToUserDefaults()
                
                // TODO: Decide if complication data refresh is really necessary here
                let complicationServer =  CLKComplicationServer.sharedInstance()
                if let complications = complicationServer.activeComplications {
                    complications.forEach({ (complication : CLKComplication) in
                        complicationServer.reloadTimeline(for: complication)
                    })
                }
                print("WatchConnectivityService -> Next Launch Data saved from received UserInfo")
            }
            catch let e {
                print("WatchConnectivityService -> Cannot Decode Userinfo into SpaceXLaunch: \(e)")
            }
        }
        #endif
    }
    
    public func session(_ session: WCSession, didFinish userInfoTransfer: WCSessionUserInfoTransfer, error: Error?) {
        print("WatchConnectivityService -> didFinish userInfoTransfer: \(userInfoTransfer.userInfo)")
        if let error = error {
            print("WatchConnectivityService -> Error: \(error)")
        }
    }
    
    public func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        isActive = activationState == .activated
        print("WatchConnectivityService -> activationDidCompleteWith: \(isActive)")
        #if os(iOS)
        if isActive, let pendingComlicationData = self.pendingComplicationData {
            self.trySendingPendingComplicationData(pendingComlicationData)
        }
        #endif
        print("Last Watch Context: \(session.applicationContext)")
    }
    
    public func sessionReachabilityDidChange(_ session: WCSession) {
        print("WatchConnectivityService -> WCSSessionReachabilityChanged to \(session.isReachable)")
    }
    
    // MARK: Message handling
    
    public func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        print("WatchConnectivityService -> didReceiveMessage:\n\(message)")
    }
    
    public func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        print("WatchConnectivityService -> didReceiveMessage:replyHandler:\n\(message)")
        replyHandler(["noted" : true])
    }
    
    public func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        print("WatchConnectivityService -> Received Application Context:\n\(applicationContext)")
    }
}
