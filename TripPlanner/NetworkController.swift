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
    func createAuthHeader(name : String, password : String) -> String {
        let pwstr = "\(name):\(password)"
        let plainData = pwstr.dataUsingEncoding(NSUTF8StringEncoding)
        let base64String = plainData?.base64EncodedStringWithOptions([])
        return "Basic \(base64String!)"
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
    func addUser(name : String, password : String) {
        let content = ["name" : name, "password" : password]
        let jsonData = try! NSJSONSerialization.dataWithJSONObject(content, options: NSJSONWritingOptions(rawValue: 0))
        let url = NSURL(string: "\(self.localUrl)user/")!
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
                    do {
                        let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions(rawValue: 0)) as! NSDictionary
                        print(json)
                    }
                    catch {
                        print(error)
                    }
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
    func getUser(id : String, username : String, password : String) {
        let authHeader = self.createAuthHeader(username, password: password)
        let url = NSURL(string: "\(self.localUrl)user/\(id)")!
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "GET"
        request.addValue(authHeader, forHTTPHeaderField: "Authorization")
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { (data : NSData?, response : NSURLResponse?, error: NSError?) -> Void in
            if let httpResponse = response as? NSHTTPURLResponse {
                switch httpResponse.statusCode {
                case 200:
                    print("everything is awesome!")
                    do {
                        let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions(rawValue: 0)) as! NSDictionary
                        print(json)
                    }
                    catch {
                        print(error)
                    }
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
    func addTrip(tripDict : NSMutableDictionary, username : String, password : String, callback : (trip : NSDictionary, errorDescription: String?) -> Void) {
        let authHeader = self.createAuthHeader(username, password: password)
        let waypoints = NSMutableArray()
        let currentDate = NSDate()
        let content = tripDict
        content["waypoints"] = waypoints
        content["lastModified"] = TypeConverter.dateToStringJSON(currentDate)
        let jsonData = try! NSJSONSerialization.dataWithJSONObject(content, options: NSJSONWritingOptions(rawValue: 0))
        let url = NSURL(string: "\(self.localUrl)trip/")!
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.HTTPBody = jsonData
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        //authentication required, so:
        request.addValue(authHeader, forHTTPHeaderField: "Authorization")
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { (data : NSData?, response : NSURLResponse?, error: NSError?) -> Void in
            if let httpResponse = response as? NSHTTPURLResponse {
                switch httpResponse.statusCode {
                case 200:
                    print("everything is awesome!")
                    do {
                        let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions(rawValue: 0)) as! NSMutableDictionary
                        let newJson = NSMutableDictionary(dictionary: json)
                        let dateStr = json["lastModified"] as! String
                        newJson["lastModified"] = TypeConverter.stringToDateJSON(dateStr)
                        callback(trip: newJson, errorDescription: error?.description)
                        print(newJson)
                    }
                    catch {
                        print(error)
                    }
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
    func updateTrip(trip : Trip, newName : String!, username : String, password : String, waypoint : Waypoint!) {
        let authHeader = self.createAuthHeader(username, password: password)
        let content = NSMutableDictionary(objects: [trip.id!], forKeys: ["_id"])
        if newName != nil {
                content["name"] = newName!
        }
        if waypoint != nil {
            var wpArr = trip.waypoints!.allObjects as! [Waypoint]
            wpArr.append(waypoint!)
            let dictArr = TypeConverter.waypointsToDict(wpArr)
            content["waypoints"] = dictArr
        }
        let currentDate = NSDate()
        content["lastModified"] = TypeConverter.dateToStringJSON(currentDate)
        
        let jsonData = try! NSJSONSerialization.dataWithJSONObject(content, options: NSJSONWritingOptions(rawValue: 0))
        let url = NSURL(string: "\(self.localUrl)trip/\(trip.id!)")!
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "PUT"
        request.HTTPBody = jsonData
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(authHeader, forHTTPHeaderField: "Authorization")
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { (data : NSData?, response : NSURLResponse?, error: NSError?) -> Void in
            if let httpResponse = response as? NSHTTPURLResponse {
                switch httpResponse.statusCode {
                case 200:
                    print("everything is awesome!")
                    do {
                        let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions(rawValue: 0)) as! NSDictionary
                        print(json)
                    }
                    catch {
                        print(error)
                    }
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
    func getTrip(tripId : String, username : String, password : String) {
        let authHeader = self.createAuthHeader(username, password: password)
        let url = NSURL(string: "\(self.localUrl)trip/\(tripId)")!
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "GET"
        request.addValue(authHeader, forHTTPHeaderField: "Authorization")
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { (data : NSData?, response : NSURLResponse?, error: NSError?) -> Void in
            if let httpResponse = response as? NSHTTPURLResponse {
                switch httpResponse.statusCode {
                case 200:
                    print("everything is awesome!")
                    do {
                        let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions(rawValue: 0)) as! NSMutableDictionary
                        let dateStr = json["lastModified"] as! String
                        json["lastModified"] = TypeConverter.stringToDateJSON(dateStr)
                        print(json)
                    }
                    catch {
                        print(error)
                    }
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
    func getAllTripsForUser(username : String, password : String, callback : (tripsArr : [NSDictionary], errorDescription: String?) -> Void) {
        let authHeader = self.createAuthHeader(username, password: password)
        let url = NSURL(string: "\(self.localUrl)trip/")!
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "GET"
        request.addValue(authHeader, forHTTPHeaderField: "Authorization")
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { (data : NSData?, response : NSURLResponse?, error: NSError?) -> Void in
            if let httpResponse = response as? NSHTTPURLResponse {
                switch httpResponse.statusCode {
                case 200:
                    print("everything is awesome!")
                    do {
                        let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions(rawValue: 0)) as! [NSMutableDictionary]
                        var newJson = [NSMutableDictionary]()
                        for eachDict in json {
                            let newDict = eachDict.mutableCopy() as! NSMutableDictionary
                            let dateStr = newDict["lastModified"] as! String
                            newDict["lastModified"] = TypeConverter.stringToDateJSON(dateStr)
                            newJson.append(newDict)
                        }
                        callback(tripsArr: newJson, errorDescription: error?.description)
                    }
                    catch {
                        print(error)
                    }
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
    func deleteTrip(tripId : String, username : String, password : String) {
        let authHeader = self.createAuthHeader(username, password: password)
        let url = NSURL(string: "\(self.localUrl)trip/\(tripId)")!
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "DELETE"
        request.addValue(authHeader, forHTTPHeaderField: "Authorization")
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { (data : NSData?, response : NSURLResponse?, error: NSError?) -> Void in
            if let httpResponse = response as? NSHTTPURLResponse {
                switch httpResponse.statusCode {
                case 200:
                    print("everything is awesome!")
                    do {
                        let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions(rawValue: 0)) as! NSDictionary
                        print(json)
                    }
                    catch {
                        print(error)
                    }
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