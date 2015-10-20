//
//  AddTripViewController.swift
//  TripPlanner
//
//  Created by Dan Hoang on 10/20/15.
//  Copyright © 2015 Dan Hoang. All rights reserved.
//

import UIKit

class AddTripViewController: UIViewController {

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

}
