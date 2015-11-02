//
//  Waypoint.swift
//  TripPlanner
//
//  Created by Dan Hoang on 11/1/15.
//  Copyright © 2015 Dan Hoang. All rights reserved.
//

import Foundation
import CoreData

class Waypoint {
    var object : NSManagedObject
    var trip : Trip
    init(object : NSManagedObject, trip : Trip) {
        self.object = object
        self.trip = trip
    }
}