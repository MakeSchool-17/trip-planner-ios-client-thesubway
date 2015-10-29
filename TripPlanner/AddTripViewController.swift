//
//  AddTripViewController.swift
//  TripPlanner
//
//  Created by Dan Hoang on 10/20/15.
//  Copyright © 2015 Dan Hoang. All rights reserved.
//

import UIKit

protocol AddTripVCDelegate {
    func tripAddedFromVC(vc : AddTripViewController, tripName : String)
}

class AddTripViewController: UIViewController {

    /* TODO: Delegate is a good idea! Add indirection by defining a protocol. */
    var delegate : AddTripVCDelegate!
    @IBOutlet var tripTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    @IBAction func addPressed(sender: AnyObject) {
        if self.tripTextField.text == "" {
            let alert = UIAlertController(title: "", message: "Please enter trip name", preferredStyle: UIAlertControllerStyle.Alert)
            let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: { _ in
            })
            alert.addAction(okAction)
            self.presentViewController(alert, animated: true, completion: {})
            return
        }
        self.delegate.tripAddedFromVC(self, tripName: self.tripTextField.text!)
        self.navigationController?.popViewControllerAnimated(true)
    }

}
