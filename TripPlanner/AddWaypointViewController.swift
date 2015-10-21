//
//  AddWaypointViewController.swift
//  TripPlanner
//
//  Created by Dan Hoang on 10/21/15.
//  Copyright © 2015 Dan Hoang. All rights reserved.
//

import UIKit

class AddWaypointViewController: UIViewController {

    @IBOutlet var searchTableView: UITableView!
    
    @IBOutlet var waypointView: UIView!
    var currentWaypoint : String!
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.currentWaypoint == nil {
            self.searchTableView.hidden = false
            self.waypointView.hidden = true
        }
        else {
            self.searchTableView.hidden = true
            self.waypointView.hidden = false
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
