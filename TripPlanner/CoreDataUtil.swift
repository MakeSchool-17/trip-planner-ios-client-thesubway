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
    
    class func coreDataAdd(value : String, key : String, entity : String) {
        let appDelegate : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context : NSManagedObjectContext = appDelegate.managedObjectContext
        let newTrip = NSEntityDescription.insertNewObjectForEntityForName("Trip", inManagedObjectContext: context)
        newTrip.setValue(value, forKey: key)
        do {
            try context.save()
            print("saved")
        } catch {
            print("could not save")
        }
    }
    class func coreDataGet(entity : String) {
        let appDelegate : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context : NSManagedObjectContext = appDelegate.managedObjectContext
        let request = NSFetchRequest(entityName: entity)
        request.returnsObjectsAsFaults = false
        var results : [AnyObject]?
        do {
            results = try context.executeFetchRequest(request)
            print(results)
        }
        catch {
            print("could not fetch")
            return
        }
    }
    
}
