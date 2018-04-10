//
//  SpaceXLaunch+CLKComplicationTimelineEntry.swift
//  WatchAppSharedLogic-watchOS
//
//  Created by Viktor Jenei on 4/10/18.
//  Copyright © 2018 Viktor Jenei. All rights reserved.
//

import Foundation
import ClockKit

public extension SpaceXLaunch {
    func circularSmallTimelineEntry(atDate date: Date) -> CLKComplicationTimelineEntry {
        let template = CLKComplicationTemplateCircularSmallRingImage()
        template.ringStyle = .closed

        template.imageProvider = CLKImageProvider(onePieceImage: UIImage(named: "RocketFlying")!)
        template.fillFraction = self.complicationFillFraction(atDate: date)

        return CLKComplicationTimelineEntry(date: date, complicationTemplate: template)
    }
}
