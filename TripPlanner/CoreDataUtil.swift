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
        } catch {
            print("could not save")
            return nil
        }
        return newTrip
    }
    class func addWaypoint(info : NSDictionary, forTrip trip : Trip) -> Waypoint? {
        let appDelegate : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context : NSManagedObjectContext = appDelegate.managedObjectContext
        let newWaypoint : Waypoint = NSEntityDescription.insertNewObjectForEntityForName("Waypoint", inManagedObjectContext: context) as! Waypoint
        newWaypoint.setValue(info["name"], forKey: "name")
        let geometry = info["geometry"] as! NSDictionary
        let location = geometry["location"] as! NSDictionary
        newWaypoint.setValue(location["lat"], forKey: "latitude")
        newWaypoint.setValue(location["lng"], forKey: "longitude")
        newWaypoint.setValue(trip, forKey: "trip")
        do {
            try context.save()
        } catch {
            print("could not save")
            return nil
        }
        return newWaypoint
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
    class func getWaypoint(key : String, value : String) -> Waypoint! {
        let appDelegate : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context : NSManagedObjectContext = appDelegate.managedObjectContext
        let request = NSFetchRequest(entityName: "Waypoint")
        request.predicate = NSPredicate(format: "\(key) = %@", value)
        request.returnsObjectsAsFaults = false
        var results : [Waypoint]?
        do {
            results = try context.executeFetchRequest(request) as? [Waypoint]
        }
        catch {
            print("could not fetch")
            return nil
        }
        if results != nil && results?.count > 0 {
            let waypoint = results![0]
            return waypoint
        }
        return nil
    }
    class func searchWaypoints(forTrip trip : Trip) -> [Waypoint]! {
        let appDelegate : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context : NSManagedObjectContext = appDelegate.managedObjectContext
        let request = NSFetchRequest(entityName: "Waypoint")
        request.predicate = NSPredicate(format: "trip = %@", trip)
        request.returnsObjectsAsFaults = false
        var waypoints : [Waypoint]?
        do {
            waypoints = try context.executeFetchRequest(request) as? [Waypoint]
        }
        catch {
            print("could not fetch")
            return nil
        }
        return waypoints
    }
    class func deleteTrip(trip: Trip) -> Bool {
        let appDelegate : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context : NSManagedObjectContext = appDelegate.managedObjectContext
        context.deleteObject(trip)
        do {
            try context.save()
        } catch {
            print("could not delete")
            return false
        }
        return true
    }
    class func deleteWaypoint(waypoint: Waypoint) -> Bool {
        let appDelegate : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context : NSManagedObjectContext = appDelegate.managedObjectContext
        context.deleteObject(waypoint)
        do {
            try context.save()
        } catch {
            print("could not delete")
            return false
        }
        return true
    }
}
