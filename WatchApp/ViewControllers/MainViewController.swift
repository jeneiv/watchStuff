//
//  MainViewController.swift
//  WatchApp
//
//  Created by Viktor Jenei on 2/21/18.
//  Copyright © 2018 Viktor Jenei. All rights reserved.
//

import UIKit
import WatchAppSharedLogic

enum MainViewError {
    case NotificationsNotAllowed
}

protocol MainView : class {
    func handleError(error : MainViewError)
    func presentNotification(withTitle title: String, withBody body: String)
}

final class MainViewController : UIViewController {
    @IBOutlet weak var liftOffButton : UIButton!
    
    private let presenter = MainPresenter()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.view = self
    }
    
    @IBAction func liftOffButtonPressed(sender: UIButton) {
        if WatchConnectivityService.sharedService.isActive {
            presenter.sendLiftOffNotification()
        }
        else if !(WatchConnectivityService.sharedService.wcSession?.isReachable ?? false) {
            print("WCSession is not reachable")
        }
        else {
            print("Nor active, nor reachable")
        }
    }
    
    @IBAction func promiseButtonPressed(sender: UIButton) {
        presenter.promiseTest()
    }
}

extension MainViewController : MainView {
    func handleError(error : MainViewError) {
        print("Notifications are not allowed")
    }
    
    func presentNotification(withTitle title: String, withBody body: String) {
        print("New Notification: \(title), \(body)")
    }
}
