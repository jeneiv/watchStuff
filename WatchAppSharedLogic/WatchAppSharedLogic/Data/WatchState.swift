//
//  WatchState.swift
//  WatchAppSharedLogic
//
//  Created by Viktor Jenei on 3/2/18.
//  Copyright © 2018 Viktor Jenei. All rights reserved.
//

import Foundation

public enum WatchAppState : Int {
    case main = 0
    case starMan
    
    public static let WatchAppStateKey = "WatchState"
    
    public func toContextDictionary() -> [String : Int] {
        return [WatchAppState.WatchAppStateKey : self.rawValue]
    }
}
