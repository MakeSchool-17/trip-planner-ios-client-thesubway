//
//  MyTripViewController.swift
//  TripPlanner
//
//  Created by Dan Hoang on 10/20/15.
//  Copyright © 2015 Dan Hoang. All rights reserved.
//

import UIKit

class MyTripViewController: UIViewController {

    @IBOutlet var hasWaypointsView: UIView!
    @IBOutlet var noWaypointsView: UIView!
    var waypoints = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.waypoints.count == 0 {
            self.view.bringSubviewToFront(self.noWaypointsView)
        }
        else {
            self.view.bringSubviewToFront(self.hasWaypointsView)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func getStartedPressed(sender: AnyObject) {
        print("get started!")
    }

}
