//
//  Trip.swift
//  TripPlanner
//
//  Created by Dan Hoang on 10/30/15.
//  Copyright © 2015 Dan Hoang. All rights reserved.
//

import UIKit

class Trip {
    var name : String
    var waypoints : [Waypoint] = []
    init(name : String) {
        self.name = name
    }
    
}