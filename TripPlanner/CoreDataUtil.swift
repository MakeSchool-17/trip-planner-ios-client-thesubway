//
//  CoreDataUtil.swift
//  TripPlanner
//
//  Created by Dan Hoang on 10/30/15.
//  Copyright © 2015 Dan Hoang. All rights reserved.
//

import UIKit
import CoreData

class CoreDataUtil {
    
    class func addTrip(value : String, key : String) -> Trip? {
        let appDelegate : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context : NSManagedObjectContext = appDelegate.managedObjectContext
        let newTrip : Trip = NSEntityDescription.insertNewObjectForEntityForName("Trip", inManagedObjectContext: context) as! Trip
        newTrip.setValue(value, forKey: key)
        do {
            try context.save()
            print("saved")
        } catch {
            print("could not save")
            return nil
        }
        return newTrip
    }
    class func getTrips() -> [Trip]! {
        let appDelegate : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context : NSManagedObjectContext = appDelegate.managedObjectContext
        let request = NSFetchRequest(entityName: "Trip")
        request.returnsObjectsAsFaults = false
        var results : [Trip]?
        do {
            results = try context.executeFetchRequest(request) as? [Trip]
        }
        catch {
            print("could not fetch")
            return nil
        }
        return results
    }
    class func searchTrip(key : String, value : String) -> [Trip]! {
        let appDelegate : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context : NSManagedObjectContext = appDelegate.managedObjectContext
        let request = NSFetchRequest(entityName: "Trip")
        request.predicate = NSPredicate(format: "\(key) = %@", value)
        request.returnsObjectsAsFaults = false
        var results : [Trip]?
        do {
            results = try context.executeFetchRequest(request) as? [Trip]
        }
        catch {
            print("could not fetch")
            return nil
        }
        return results
    }
}
