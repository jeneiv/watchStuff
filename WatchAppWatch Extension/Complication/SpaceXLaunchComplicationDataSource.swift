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
        handler([.backward, .forward])
    }
    
    func getCurrentTimelineEntry(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimelineEntry?) -> Swift.Void) {
        if complication.family == .circularSmall {
            let template = CLKComplicationTemplateCircularSmallRingImage()
            template.ringStyle = .closed
            
            if let storedNextLaunch = SpaceXLaunch.fromUserDefaults(), storedNextLaunch.doesLauncheToday {
                template.imageProvider = CLKImageProvider(onePieceImage: UIImage(named: "RocketFlying")!)
                template.fillFraction = storedNextLaunch.complicationFillFraction
                let timelineEntry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template)
                handler(timelineEntry)
            }
            else {
                template.imageProvider = CLKImageProvider(onePieceImage: UIImage(named: "RocketStanding")!)
                template.fillFraction = 0.0
                let timelineEntry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template)
                handler(timelineEntry)
            }

        }
        else {
            handler(Optional.none)
        }
    }
    
    func getTimelineEndDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
        handler(SpaceXLaunch.fromUserDefaults()?.localLaunchDate)
    }
    
    func getTimelineAnimationBehavior(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimelineAnimationBehavior) -> Void) {
        handler(CLKComplicationTimelineAnimationBehavior.always)
    }
    
    func getTimelineEntries(for complication: CLKComplication, after date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
        if complication.family == .circularSmall {
            let template = CLKComplicationTemplateCircularSmallRingImage()
            template.ringStyle = .closed
            
            if let storedNextLaunch = SpaceXLaunch.fromUserDefaults(), storedNextLaunch.doesLaunch(atDate: date) {
                template.imageProvider = CLKImageProvider(onePieceImage: UIImage(named: "RocketFlying")!)
                template.fillFraction = storedNextLaunch.complicationFillFraction(atDate: date)
                let timelineEntry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template)
                handler([timelineEntry])
            }
            else {
                template.imageProvider = CLKImageProvider(onePieceImage: UIImage(named: "RocketStanding")!)
                template.fillFraction = 0.0
                let timelineEntry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template)
                handler([timelineEntry])
            }
        }
        handler(Optional.none)
    }
}
