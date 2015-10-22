//
//  AddWaypointViewController.swift
//  TripPlanner
//
//  Created by Dan Hoang on 10/21/15.
//  Copyright © 2015 Dan Hoang. All rights reserved.
//

import UIKit
import MapKit

class AddWaypointViewController: UIViewController, MKMapViewDelegate, UISearchBarDelegate, CLLocationManagerDelegate {

    @IBOutlet var searchTableView: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    
    @IBOutlet var waypointView: UIView!
    var currentWaypoint : String!
    @IBOutlet var lblWaypoint: UILabel!
    
    @IBOutlet var mapView: MKMapView!
    var locationManager = CLLocationManager()
    var userCoordinate : CLLocationCoordinate2D!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchBar.delegate = self
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
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        self.view.endEditing(true)
        
        if CLLocationManager.locationServicesEnabled() == false {
            print("location services disabled")
            return
        }
        else {
            print("location services enabled!")
        }
        
        self.locationManager.delegate = self
        
        if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.NotDetermined {
            //add NSLocationWhenInUsageDescription and NSLocationAlwaysUsageDescription, as keys, to plist
            self.locationManager.requestWhenInUseAuthorization()
            print("requesting for authorization")
        }
        else if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.Denied {
            print("status denied")
            return
        }
        else {
            print("enabled")
        }
        
        //after user confirmation (authorized), then may update location
        self.locationManager.startUpdatingLocation()
        //that should call locationManager's didUpdateLocations function.
        
        //in order to have current location, must have CLLocation.
        
        //before actually inputting the searchString, must have access to current region.
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation : CLLocation! = locations.last
        self.userCoordinate = userLocation.coordinate
        //after search, no longer need to update extra times.
        manager.stopUpdatingLocation()
        //ensure that didUpdateLocations no longer gets called:
        manager.delegate = nil
        self.startSearch(self.searchBar.text!)
    }
    
    func startSearch(searchString: String) {
        print("search for \(searchString)")
        print("searching at: \(self.userCoordinate.latitude) latitude, \(self.userCoordinate.longitude) longitude")
    }

}
