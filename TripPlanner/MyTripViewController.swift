//
//  MyTripViewController.swift
//  TripPlanner
//
//  Created by Dan Hoang on 10/20/15.
//  Copyright © 2015 Dan Hoang. All rights reserved.
//

import UIKit
import CoreData

class MyTripViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, AddWaypointVCDelegate {

    @IBOutlet var hasWaypointsView: UIView!
    @IBOutlet var tripImageView: UIImageView!
    @IBOutlet var lblDestination: UILabel!
    @IBOutlet var lblTravelDate: UILabel!
    var trip : Trip!
    
    @IBOutlet var noWaypointsView: UIView!
    // TODO: waypoints: [String] = [] would be more typical for swift
    var waypoints: [NSDictionary] = []
    @IBOutlet var waypointTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CoreDataUtil.coreDataSearch("Trip", key: "name", value: self.trip.name)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if self.waypoints.count == 0 {
            self.noWaypointsView.hidden = false
            self.hasWaypointsView.hidden = true
        }
        else {
            self.noWaypointsView.hidden = true
            self.hasWaypointsView.hidden = false
        }
        // TODO: duplicate line
        waypointTableView.delegate = self
        waypointTableView.dataSource = self
        self.lblDestination.text = "Destination: \(self.trip.name)"
        self.lblTravelDate.text = "Travel Date: 07/11/16"
        self.waypointTableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func getStartedPressed(sender: AnyObject) {
        self.addWayPoints(nil)
    }
    @IBAction func addMorePressed(sender: AnyObject) {
        self.addWayPoints(nil)
    }
    
    func waypointAddedFromVC(dict: NSDictionary) {
        self.waypoints.append(dict)
    }
  
    // TODO: I would call this `tapped` waypoint
    func addWayPoints(tappedWaypoint: NSDictionary!) {
        let addWaypointVC = self.storyboard?.instantiateViewControllerWithIdentifier("addWaypointVC") as? AddWaypointViewController
        addWaypointVC?.delegate = self
        if tappedWaypoint != nil {
            addWaypointVC?.currentWaypoint = tappedWaypoint
        }
        self.navigationController?.pushViewController(addWaypointVC!, animated: true)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let waypoint : NSDictionary = self.waypoints[indexPath.row] as NSDictionary
        self.addWayPoints(waypoint)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.waypoints.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("waypointCell")
        let waypoint : NSDictionary = waypoints[indexPath.row]
        cell?.textLabel?.text = waypoint["name"] as? String
        return cell!
    }

}
