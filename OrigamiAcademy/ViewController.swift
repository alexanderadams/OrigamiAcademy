//
//  ViewController.swift
//  OrigamiAcademy
//
//  Created by Alexander Adams on 10/4/16.
//  Copyright © 2016 adams. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    let loginSegue:String = "loginSegue"
    let newUserSegue:String = "newUserSegue"
    let notNowSegue:String = "notNowSegue"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
       
        if segue.identifier == loginSegue {
            let destination = segue.destinationViewController as? AuthenticationController
            destination?.newUser = false
        } else if segue.identifier == newUserSegue {
            let destination = segue.destinationViewController as? AuthenticationController
            destination?.newUser = true
        } else {
            
        }
    }


}
