//
//  ViewController.swift
//  TripPlanner
//
//  Created by Dan Hoang on 10/12/15.
//  Copyright © 2015 Dan Hoang. All rights reserved.
//

import UIKit

class PlannedTripsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, AddTripVCDelegate {

    @IBOutlet var tableView: UITableView!
    var trips = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        trips.append("Trip to San Francisco")
        trips.append("Trip to Stuttgart")
        trips.append("Trip to Moscow")
        trips.append("Trip to Brasilia")
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
        let myTripVC = self.storyboard?.instantiateViewControllerWithIdentifier("myTripVC") as! MyTripViewController
        for (var i = 0; i < indexPath.row; i++) {
            myTripVC.waypoints.append("Trip \(i)")
        }
        self.navigationController?.pushViewController(myTripVC, animated: true)
    }

    @IBAction func addPressed(sender: AnyObject) {
        let addTripVC = self.storyboard?.instantiateViewControllerWithIdentifier("addTripVC") as! AddTripViewController
        addTripVC.delegate = self
        self.navigationController?.pushViewController(addTripVC, animated: true)
    }
    
    func tripAddedFromVC(tripName: String) {
        self.trips.append(tripName)
        self.tableView.reloadData()
    }
}

