//
//  Waypoint+CoreDataProperties.swift
//  TripPlanner
//
//  Created by Dan Hoang on 11/6/15.
//  Copyright © 2015 Dan Hoang. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Waypoint {

    @NSManaged var latitude: NSNumber?
    @NSManaged var longitude: NSNumber?
    @NSManaged var name: String?
    @NSManaged var lastModified: NSDate?
    @NSManaged var trip: Trip?

}
