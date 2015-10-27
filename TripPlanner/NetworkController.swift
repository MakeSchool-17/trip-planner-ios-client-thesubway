//
//  NetworkController.swift
//  TripPlanner
//
//  Created by Dan Hoang on 10/26/15.
//  Copyright © 2015 Dan Hoang. All rights reserved.
//

import Foundation
import MapKit

class NetworkController  {
    
    init() {
    }
    
    func fetchPlaces(searchString : String!, userCoordinate: CLLocationCoordinate2D!, callback: (places: [NSDictionary]?,
        errorDescription: String?) -> Void) -> Void {
            let serverKey = "AIzaSyC81O4yTA6Urd0s-OxGUT2SEfvv43xU_Tk"
            let url = NSURL(string: "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(userCoordinate.latitude),\(userCoordinate.longitude)&radius=500&types=food&name=\(searchString)&key=\(serverKey)")
            let urlRequest = NSURLRequest(URL: url!)
            let session = NSURLSession.sharedSession()
            let task = session.dataTaskWithRequest(urlRequest) { (data : NSData?, response : NSURLResponse?, error : NSError?) -> Void in
                if let httpResponse = response as? NSHTTPURLResponse {
                    switch httpResponse.statusCode {
                    case 200:
                        print("everything is awesome!")
                        do {
                            let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions(rawValue: 0)) as! NSDictionary
                            let results : [NSDictionary] = json["results"] as! [NSDictionary]
                            callback(places: results, errorDescription: error?.description)
                            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                            //                        print(results)
                        }
                        catch {
                            print(error)
                        }
                    case 404:
                        print("not found")
                        callback(places: nil, errorDescription: error?.description)
                    default:
                        print("error \(httpResponse.statusCode)")
                        callback(places: nil, errorDescription: error?.description)
                    }
                }
            }
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            task.resume()
    }
    
}