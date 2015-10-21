//
//  AddWaypointViewController.swift
//  TripPlanner
//
//  Created by Dan Hoang on 10/21/15.
//  Copyright © 2015 Dan Hoang. All rights reserved.
//

import UIKit
import MapKit

class AddWaypointViewController: UIViewController, UITextFieldDelegate, MKMapViewDelegate {

    @IBOutlet var searchTableView: UITableView!
    @IBOutlet var searchTextField: UITextField!
    
    @IBOutlet var waypointView: UIView!
    var currentWaypoint : String!
    @IBOutlet var lblWaypoint: UILabel!
    
    @IBOutlet var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchTextField.delegate = self
        self.mapView.delegate = self
        if self.currentWaypoint != nil {
            self.searchTableView.hidden = true
            self.waypointView.hidden = false
            self.lblWaypoint.text = currentWaypoint
        }
        else {
            self.searchTableView.hidden = false
            self.waypointView.hidden = true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }

}
