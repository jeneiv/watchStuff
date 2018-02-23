//
//  WatchConnectivityService.swift
//  WatchApp
//
//  Created by Viktor Jenei on 2/19/18.
//  Copyright © 2018 Viktor Jenei. All rights reserved.
//

import Foundation
import WatchConnectivity

public final class WatchConnectivityService : NSObject {
    public static let sharedService = WatchConnectivityService()
    
    private (set) public var wcSession : WCSession?
    private (set) public var isActive = false {
        didSet {
            print("New WatchConnectivityService.isActive state: \(isActive)")
        }
    }
    
    private override init() {
        if WCSession.isSupported() {
            print("WCsession is supportted")
            
            wcSession = WCSession.default
            
            super.init()
            
            wcSession?.delegate = self
            wcSession?.activate()
        }
        else {
            super.init()
            print("WCsession is NOT supportted")
        }
    }
}

// MARK: - WCSSessionDelegate

extension WatchConnectivityService : WCSessionDelegate {
    
    // MARK: State handling
    
    public func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("WatchConnectivityService -> activationDidComplete")
        isActive = true
    }
    
    #if os(iOS)
    public func sessionDidBecomeInactive(_ session: WCSession) {
        print("WatchConnectivityService -> sessionDidBecomeInactive")
        isActive = false
    }
    
    public func sessionDidDeactivate(_ session: WCSession) {
        print("WatchConnectivityService -> sessionDidDeactivate")
        isActive = false
    }
    #endif
    
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
        
    }
}




