//
//  SpaceXLaunchComplicationDataSource.swift
//  WatchAppWatch Extension
//
//  Created by Viktor Jenei on 3/14/18.
//  Copyright © 2018 Viktor Jenei. All rights reserved.
//

import Foundation
import ClockKit
import WatchAppSharedLogic_watchOS

class SpaceXLaunchComplicationDataSource : NSObject, CLKComplicationDataSource {
    func getPrivacyBehavior(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationPrivacyBehavior) -> Void) {
        handler(CLKComplicationPrivacyBehavior.showOnLockScreen)
    }
    
    func getSupportedTimeTravelDirections(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimeTravelDirections) -> Swift.Void) {
        handler([.forward])
    }
    
    func getCurrentTimelineEntry(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimelineEntry?) -> Swift.Void) {
        if complication.family == .circularSmall {
            if let storedNextLaunch = SpaceXLaunch.fromUserDefaults(), storedNextLaunch.doesLauncheToday {
                let template = CLKComplicationTemplateCircularSmallRingImage()
                template.ringStyle = .closed
                template.imageProvider = CLKImageProvider(onePieceImage: UIImage(named: "RocketFlying")!)
                template.fillFraction = storedNextLaunch.complicationFillFraction
                let timelineEntry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template)
                handler(timelineEntry)
            }
            else {
                handler(self.emptyLaunchComplicationCircularSmallTimelineEntry())
            }

        }
        else {
            handler(Optional.none)
        }
    }
    
    func getTimelineStartDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
        if let nextLaunchDate = SpaceXLaunch.fromUserDefaults()?.localLaunchDate {
            handler(Calendar.current.startOfDay(for: nextLaunchDate))
        }
        handler(Optional.none)
    }
    
    func getTimelineEndDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
        if let nextLaunchDate = SpaceXLaunch.fromUserDefaults()?.localLaunchDate {
            // Timeline Entry Expires 1 hour after launch
            let expireData = nextLaunchDate.addingTimeInterval(60.0 * 60.0)
            handler(expireData)
        }
        else {
            handler(Optional.none)
        }
    }
    
    func getTimelineAnimationBehavior(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimelineAnimationBehavior) -> Void) {
        handler(CLKComplicationTimelineAnimationBehavior.never)
    }
    
    func getTimelineEntries(for complication: CLKComplication, after date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
        if complication.family == .circularSmall {
            if limit > 0, let storedNextLaunch = SpaceXLaunch.fromUserDefaults(), let storedLaunchDate = storedNextLaunch.localLaunchDate, storedNextLaunch.doesLaunch(atDate: date), storedLaunchDate > date {
                let difference = storedLaunchDate.timeIntervalSince(date)
                let limit = limit <= 24 ? limit : 24

                let proportion = difference / Double(limit)
                var entries = [CLKComplicationTimelineEntry]()
                for i in 0..<(limit - 1) {
                    let entryDate = Date(timeIntervalSinceNow: (Double(i) * proportion))
                    if entryDate < storedLaunchDate {
                        entries.append(storedNextLaunch.circularSmallTimelineEntry(atDate: entryDate))
                    }
                }
                
                entries.append(self.emptyLaunchComplicationCircularSmallTimelineEntry(forDate: storedLaunchDate))
                handler(entries)
            }
            else {
                handler([self.emptyLaunchComplicationCircularSmallTimelineEntry()])
            }
        }
        handler(Optional.none)
    }
}

extension SpaceXLaunchComplicationDataSource {
    private func emptyLaunchComplicationCircularSmallTimelineEntry(forDate date: Date = Date()) -> CLKComplicationTimelineEntry {
        let template = CLKComplicationTemplateCircularSmallRingImage()
        template.ringStyle = .closed
        template.imageProvider = CLKImageProvider(onePieceImage: UIImage(named: "RocketStanding")!)
        template.fillFraction = 0.0
        return CLKComplicationTimelineEntry(date: date, complicationTemplate: template)
    }
}
