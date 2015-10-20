//
//  ViewController.swift
//  TripPlanner
//
//  Created by Dan Hoang on 10/12/15.
//  Copyright © 2015 Dan Hoang. All rights reserved.
//

import UIKit

class PlannedTripsViewController: UIViewController {

    var trips = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        trips.append("Trip to San Francisco")
        trips.append("Trip to Stuttgart")
        trips.append("Trip to Moscow")
        trips.append("Trip to Brasilia")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

