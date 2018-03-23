//
//  SpaceXLaunchComplicationDataSource.swift
//  WatchAppWatch Extension
//
//  Created by Viktor Jenei on 3/14/18.
//  Copyright © 2018 Viktor Jenei. All rights reserved.
//

import Foundation
import ClockKit

class SpaceXLaunchComplicationDataSource : NSObject, CLKComplicationDataSource {
    func getPrivacyBehavior(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationPrivacyBehavior) -> Void) {
        handler(CLKComplicationPrivacyBehavior.showOnLockScreen)
    }
    
    func getSupportedTimeTravelDirections(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimeTravelDirections) -> Swift.Void) {
        handler([.forward, .backward])
    }
    
    func getCurrentTimelineEntry(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimelineEntry?) -> Swift.Void) {
        if complication.family == .circularSmall {
            let template = CLKComplicationTemplateCircularSmallRingImage()
            template.ringStyle = .closed
            template.imageProvider = CLKImageProvider(onePieceImage: UIImage(named: "RocketStanding")!)
            template.fillFraction = 0.5
            let timelineEntry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template)
            handler(timelineEntry)
        }
        else {
            handler(Optional.none)
        }
    }
}
