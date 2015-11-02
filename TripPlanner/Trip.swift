//
//  Trip.swift
//  TripPlanner
//
//  Created by Dan Hoang on 10/30/15.
//  Copyright © 2015 Dan Hoang. All rights reserved.
//

import UIKit
import CoreData

class Trip {
    var object : NSManagedObject
    var name : String
    var waypoints : [Waypoint] = []
    init(object : NSManagedObject) {
        self.object = object
        self.name = object.valueForKey("name") as! String
    }
    
}