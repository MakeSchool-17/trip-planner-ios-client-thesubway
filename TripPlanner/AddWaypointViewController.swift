//
//  AddWaypointViewController.swift
//  TripPlanner
//
//  Created by Dan Hoang on 10/21/15.
//  Copyright © 2015 Dan Hoang. All rights reserved.
//

import UIKit
import MapKit

class AddWaypointViewController: UIViewController, MKMapViewDelegate, UISearchBarDelegate, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var searchTableView: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    
    @IBOutlet var waypointView: UIView!
    var currentWaypoint : String!
    @IBOutlet var lblWaypoint: UILabel!
    
    @IBOutlet var mapView: MKMapView!
    var locationManager = CLLocationManager()
    var userCoordinate : CLLocationCoordinate2D!
    var localSearch : MKLocalSearch!
    var places = [MKMapItem]()
    var boundingRegion : MKCoordinateRegion!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchBar.delegate = self
        self.mapView.delegate = self
        self.searchTableView.delegate = self
        self.searchTableView.dataSource = self
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
        self.searchTableView.hidden = false
        self.waypointView.hidden = true
        
        if self.localSearch != nil && self.localSearch?.searching == true {
            self.localSearch!.cancel()
        }
        //use the user's current region
        var newRegion = MKCoordinateRegion()
        newRegion.center.latitude = self.userCoordinate.latitude
        newRegion.center.longitude = self.userCoordinate.longitude
        
        //smaller delta values mean higher zoom level
        newRegion.span.latitudeDelta = 0.112872
        newRegion.span.longitudeDelta = 0.109863
        
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = searchString
        request.region = newRegion
        
        //completion handler
        
        if self.localSearch != nil {
            self.localSearch = nil
        }
        self.localSearch = MKLocalSearch(request: request)
        self.localSearch.startWithCompletionHandler { (response: MKLocalSearchResponse?, error: NSError?) -> Void in
            if error != nil {
                let errorStr : String = (error?.userInfo[NSLocalizedDescriptionKey] as? String)!
                let alert = UIAlertController(title: "Could not find places", message: errorStr, preferredStyle: UIAlertControllerStyle.Alert)
                let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: { _ in
                })
                alert.addAction(okAction)
                self.presentViewController(alert, animated: true, completion: {})
            }
            else {
                self.places = response!.mapItems
                self.boundingRegion = response?.boundingRegion
                print("num places: \(self.places.count)")
                print(self.places)
                self.searchTableView.reloadData()
            }
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.places.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("searchCell")
        let mapItem : MKMapItem = self.places[indexPath.row]
        cell?.textLabel?.text = mapItem.placemark.description
        return cell!
    }

}
