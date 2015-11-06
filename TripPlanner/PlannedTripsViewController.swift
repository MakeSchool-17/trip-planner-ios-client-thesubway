//
//  ViewController.swift
//  TripPlanner
//
//  Created by Dan Hoang on 10/12/15.
//  Copyright © 2015 Dan Hoang. All rights reserved.
//

import UIKit
import CoreData

class PlannedTripsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, AddTripVCDelegate {

    @IBOutlet var tableView: UITableView!
    var trips = [Trip]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let cdTrips = CoreDataUtil.getTrips() as [Trip]
        for eachTrip in cdTrips {
            self.trips.append(eachTrip)
        }
        self.tableView.delegate = self
        self.tableView.dataSource = self
        let networkC = NetworkController()
        networkC.getAllTripsForUser("MyUser1", password: "password2") { (tripsArr, errorDescription) -> Void in
            dispatch_async(dispatch_get_main_queue(), {
                for eachDict in tripsArr {
                    let eachName = eachDict["name"] as! String
                    let eachTrip = CoreDataUtil.addTrip(eachName, key: "name")
                    if eachTrip != nil {
                        self.trips.append(eachTrip!)
                    }
                }
                self.tableView.reloadData()
                print(tripsArr)
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            let trip = self.trips[indexPath.row]
            let waypoints = CoreDataUtil.searchWaypoints(forTrip: trip) as [Waypoint]
            let deleteResult = CoreDataUtil.deleteTrip(trip)
            if deleteResult == true {
                for eachWaypoint in waypoints {
                    CoreDataUtil.deleteWaypoint(eachWaypoint)
                }
                self.trips.removeAtIndex(indexPath.row)
                self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            }
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.trips.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("tripCell")
        let cellTrip = self.trips[indexPath.row]
        cell?.textLabel?.text = cellTrip.name
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        /* TODO: You *could* use a regular segue here - I don't have strong opinions against
          instantiating the VC programatically though :) */
        // TODO: Consider choosing a different name than `myTripVC`
        let myTripVC = self.storyboard?.instantiateViewControllerWithIdentifier("myTripVC") as! MyTripViewController
        /* TODO: Here it would be better to use a View Object (covered in this lecture: https://www.makeschool.com/academy/tutorial/ios-development-class/intro-to-ios-app-architecture).
          I would recommend passing the entire trip to the tripVC, then the tripVC itself can extract
          the date and destination from the trip.
        */
        myTripVC.trip = self.trips[indexPath.row]
        self.navigationController?.pushViewController(myTripVC, animated: true)
    }

    @IBAction func addPressed(sender: AnyObject) {
        let addTripVC = self.storyboard?.instantiateViewControllerWithIdentifier("addTripVC") as! AddTripViewController
        addTripVC.delegate = self
        self.navigationController?.pushViewController(addTripVC, animated: true)
    }
  
    /* TODO: It would be prefarable to communicate via a protocol instead of having this method being
       called directly */
    func tripAddedFromVC(vc: AddTripViewController, tripName: String) {
        let currentTrip = CoreDataUtil.addTrip(tripName, key: "name")
        var arrResults = CoreDataUtil.searchTrip("name", value: tripName) as [NSManagedObject]
        if currentTrip != nil {
            self.trips.append(currentTrip!)
        }
        arrResults = CoreDataUtil.getTrips() as [Trip]
        print(arrResults)
        self.tableView.reloadData()
    }
}

