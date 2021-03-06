//
//  Trip+CoreDataProperties.swift
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

extension Trip {

    @NSManaged var id: String?
    @NSManaged var lastModified: NSDate?
    @NSManaged var name: String?
    @NSManaged var waypoints: NSSet?

}
