//
//  MyTripViewController.swift
//  TripPlanner
//
//  Created by Dan Hoang on 10/20/15.
//  Copyright © 2015 Dan Hoang. All rights reserved.
//

import UIKit

class MyTripViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var hasWaypointsView: UIView!
    @IBOutlet var tripImageView: UIImageView!
    @IBOutlet var lblDestination: UILabel!
    @IBOutlet var lblTravelDate: UILabel!
    
    @IBOutlet var noWaypointsView: UIView!
    var waypoints = [String]()
    @IBOutlet var waypointTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.waypoints.count == 0 {
            self.view.bringSubviewToFront(self.noWaypointsView)
        }
        else {
            self.view.bringSubviewToFront(self.hasWaypointsView)
        }
        self.waypointTableView.delegate = self
        self.waypointTableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func getStartedPressed(sender: AnyObject) {
        self.addWayPoints(false)
    }
    @IBAction func addMorePressed(sender: AnyObject) {
        self.addWayPoints(true)
    }
    
    func addWayPoints(hasWaypoints: Bool) {
        if hasWaypoints {
            print("add more")
        }
        else {
            print("get started!")
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.waypoints.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("waypointCell")
        cell?.textLabel?.text = waypoints[indexPath.row]
        return cell!
    }

}
