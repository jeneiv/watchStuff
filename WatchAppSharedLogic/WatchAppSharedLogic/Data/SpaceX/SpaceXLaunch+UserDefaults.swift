//
//  SpaceXLaunch+UserDefaults.swift
//  WatchAppSharedLogic
//
//  Created by Viktor Jenei on 3/21/18.
//  Copyright © 2018 Viktor Jenei. All rights reserved.
//

import Foundation

public extension SpaceXLaunch {
    static let NextLaunchDataKey = "NextLaunchDataKey"
    
    func saveToUserDefaults(withKey key: String = SpaceXLaunch.NextLaunchDataKey) {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(self)
            UserDefaults.standard.set(data, forKey: SpaceXLaunch.NextLaunchDataKey)
        }
        catch let e {
            print("Saving Launch into UserDefaults failed with error: \(e)")
        }
    }
    
    static func fromUserDefaults(withKey key: String = SpaceXLaunch.NextLaunchDataKey) -> SpaceXLaunch? {
        var storedLaunch : SpaceXLaunch? = Optional.none
        
        if let nextLaunchData = UserDefaults.standard.value(forKey: SpaceXLaunch.NextLaunchDataKey) as? Data {
            let decoder = JSONDecoder()
            do {
                storedLaunch = try decoder.decode(SpaceXLaunch.self, from: nextLaunchData)
            }
            catch let e {
                print("Retrieving Launch from UserDefaults failed with error: \(e)")
            }
        }
        
        return storedLaunch
    }
}
