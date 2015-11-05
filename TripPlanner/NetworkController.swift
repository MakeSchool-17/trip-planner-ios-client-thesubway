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
    
    let serverKey = "AIzaSyC81O4yTA6Urd0s-OxGUT2SEfvv43xU_Tk"
    let localUrl = "http://127.0.0.1:5000/"
    init() {
    }
    
    func fetchPlaces(searchString : String!, userCoordinate: CLLocationCoordinate2D!, callback: (places: [NSDictionary]?,
        errorDescription: String?) -> Void) -> Void {
            let url = NSURL(string: "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(userCoordinate.latitude),\(userCoordinate.longitude)&radius=500&types=food&name=\(searchString)&key=\(self.serverKey)")
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
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                }
            }
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            task.resume()
    }
    
    func fetchDetailsOfPlace(placeId : String, callback : (details : NSDictionary, errorDescription: String?) -> Void) -> Void {
        let url = NSURL(string: "https://maps.googleapis.com/maps/api/place/details/json?placeid=\(placeId)&key=\(self.serverKey)")
        let urlRequest = NSURLRequest(URL: url!)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(urlRequest) { (data : NSData?, response : NSURLResponse?, error : NSError?) -> Void in
            if let httpResponse = response as? NSHTTPURLResponse {
                switch httpResponse.statusCode {
                case 200:
                    print("everything is awesome!")
                    do {
                        let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions(rawValue: 0)) as! NSDictionary
                        callback(details: json, errorDescription: error?.description)
                    }
                    catch {
                        print(error)
                    }
                case 404:
                    print("not found")
                default:
                    print("error \(httpResponse.statusCode)")
                }
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            }
        }
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        task.resume()
    }
    func addMyObject(name : String) {
        let content = ["name" : name]
        let jsonData = try! NSJSONSerialization.dataWithJSONObject(content, options: NSJSONWritingOptions(rawValue: 0))
        let url = NSURL(string: "\(self.localUrl)myobject/")!
        let urlRequest = NSMutableURLRequest(URL: url)
        urlRequest.HTTPMethod = "POST"
        urlRequest.HTTPBody = jsonData
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(urlRequest) { (data : NSData?, response : NSURLResponse?, error: NSError?) -> Void in
            if let httpResponse = response as? NSHTTPURLResponse {
                switch httpResponse.statusCode {
                case 200:
                    print("everything is awesome!")
                case 404:
                    print("not found")
                default:
                    print("error \(httpResponse.statusCode)")
                    print(httpResponse)
                }
            }
        }
        task.resume()
    }
    
}