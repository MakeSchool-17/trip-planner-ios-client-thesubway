//
//  TypeConverter.swift
//  TripPlanner
//
//  Created by Dan Hoang on 11/6/15.
//  Copyright © 2015 Dan Hoang. All rights reserved.
//

import UIKit

class TypeConverter {
    class func waypointsToDict(waypoints : [Waypoint]) -> [NSDictionary] {
        var dictArr : [NSDictionary] = []
        for eachWaypoint in waypoints {
            let objectArr = NSMutableArray(objects: eachWaypoint.name!, eachWaypoint.latitude!, eachWaypoint.longitude!)
            let keyArr = ["name", "latitude", "longitude"]
            let waypointDict = NSMutableDictionary(objects: objectArr as [AnyObject], forKeys: keyArr)
            dictArr.append(waypointDict)
        }
        return dictArr
    }
    class func dictsToWpsToSet(dicts : [NSDictionary], trip : Trip) -> NSSet {
        //this function requires access to core data
        var wpArr : [Waypoint] = []
        for eachDict in dicts {
            let wpName = eachDict["name"] as! String
            var existingWaypoint = CoreDataUtil.getWaypoint("name", value: wpName)
            if existingWaypoint == nil {
                existingWaypoint = CoreDataUtil.addWaypoint(eachDict, forTrip: trip)
            }
            wpArr.append(existingWaypoint)
        }
        let wpSet = NSSet(array: wpArr)
        return wpSet
    }
    class func stringToDateJSON(dateString : String) -> NSDate {
        let dateFormatter : NSDateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd'T'HH:mm:ssZZZ"
        return dateFormatter.dateFromString(dateString)!
    }
    class func dateToStringJSON(date : NSDate) -> String {
        let dateFormatter : NSDateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd'T'HH:mm:ssZZZ"
        return dateFormatter.stringFromDate(date)
    }
}
