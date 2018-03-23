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
    func displayNextLaunch(launch: SpaceXLaunch?)
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
    
    @IBAction func checkStoredNextLaunchData(sender: UIButton) {
        presenter.fetchStoredNextLaunch()
    }
    
    @IBAction func fetchNextLaunchButtonPressed(sender: UIButton) {
        presenter.fetchNextLaunch()
    }
}

extension MainViewController : MainView {
    func handleError(error : MainViewError) {
        print("Notifications are not allowed")
    }
    
    func presentNotification(withTitle title: String, withBody body: String) {
        print("New Notification: \(title), \(body)")
    }
    
    func displayNextLaunch(launch: SpaceXLaunch?) {
        let alert = UIAlertController(title: "Next Launch", message: launch != Optional.none ? "Flight num: \(launch!.flightNumber)" : "No Launch", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: Optional.none))
        self.present(alert, animated: true, completion: Optional.none)
    }
}
