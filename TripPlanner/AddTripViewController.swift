//
//  AddTripViewController.swift
//  TripPlanner
//
//  Created by Dan Hoang on 10/20/15.
//  Copyright © 2015 Dan Hoang. All rights reserved.
//

import UIKit

protocol AddTripVCDelegate {
    func tripAddedFromVC(tripName : String)
}

class AddTripViewController: UIViewController {

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
        self.delegate.tripAddedFromVC(self.tripTextField.text!)
        self.navigationController?.popViewControllerAnimated(true)
    }

}
