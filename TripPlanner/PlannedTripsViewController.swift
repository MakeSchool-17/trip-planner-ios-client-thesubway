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
    var trips = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let cdTrips = CoreDataUtil.coreDataGet("Trip") as! [NSManagedObject]
        for eachTrip in cdTrips {
            let trip = Trip(name: eachTrip.valueForKey("name") as! String)
            self.trips.append(trip.name)
        }
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.trips.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("tripCell")
        cell?.textLabel?.text = self.trips[indexPath.row]
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
        myTripVC.tripDestination = "Destination: \(self.trips[indexPath.row])"
        myTripVC.tripTravelDate = "Travel Date: 07/11/16"
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
        CoreDataUtil.coreDataAdd(tripName, key: "name", entity: "Trip")
        self.trips.append(tripName)
        CoreDataUtil.coreDataGet("Trip")
        self.tableView.reloadData()
    }
}

