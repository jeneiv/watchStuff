//
//  MainPresenter.swift
//  WatchApp
//
//  Created by Viktor Jenei on 2/22/18.
//  Copyright © 2018 Viktor Jenei. All rights reserved.
//

import Foundation
import UserNotifications
import WatchAppSharedLogic
import PromiseKit

final class MainPresenter : NSObject {
    weak var view : MainView?
    let notificationCenter : UNUserNotificationCenter
    
    override init() {
        notificationCenter = UNUserNotificationCenter.current()
        
        super.init()
    }
    
    func fetchNextLaunch() {
        SpaceXLaunch.getUpcomingLaunches().done(on: DispatchQueue.main) { result in
            // print("Promise.done: \(result)")
            if let nextLaunch = result.first {
                nextLaunch.saveToUserDefaults()
                do {
                    try UpcomingLaunchComplicationDataService.sendComplicationData(forNextLaunch: nextLaunch)
                }
                catch let e {
                    print("AppDelegate - Error Sending Complication Data to watch: \(e)")
                    WatchConnectivityService.sharedService.pendingComplicationData = nextLaunch
                }
                print("Next Launch Stored")
            }
            else {
                print("No data for next launch")
            }
        }
        .catch { error in
            print("Promise.catch: \(error)")
        }
    }
    
    func fetchStoredNextLaunch() {
        let storedNextLaunch = SpaceXLaunch.fromUserDefaults()
        print("Stored Next Launch Data: \(String(describing: storedNextLaunch))")
        self.view?.displayNextLaunch(launch: storedNextLaunch)
    }
    
    func sendLiftOffNotification() {
        notificationCenter.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            if let _ = error {
                self.view?.handleError(error: MainViewError.NotificationsNotAllowed)
            }
            else if granted {
                let notificationContent = self.liftOffNotificationContent()
                self.notificationCenter.delegate = self
                
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 15, repeats: false)
                
                // Schedule the notification.
                let request = UNNotificationRequest(identifier: "com.watchapp.liftoffNotificationIdentifier", content: notificationContent, trigger: trigger)
                self.notificationCenter.add(request, withCompletionHandler: nil)
                
                print("Notification Dispatched")
            }
            else {
                print("Unknown error when checking Notification Autorization")
            }
        }
    }
    
    private func liftOffNotificationContent() -> UNMutableNotificationContent {
        let content = UNMutableNotificationContent()
        
        content.title = "LiftOff"
        content.body = "Whoooooooo"
        content.sound = UNNotificationSound.default()
        
        return content
    }
}

extension MainPresenter : UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Swift.Void) {
        print("Notification has arrived (\(notification.request.content.title); \(notification.request.content.body))")
    }
}
