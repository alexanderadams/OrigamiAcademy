//
//  SettingsController.swift
//  OrigamiAcademy
//
//  Created by Christiano Contreras on 10/17/16.
//  Copyright © 2016 adams. All rights reserved.
//

import Foundation
import UIKit
import CoreData

import Firebase

class settingsController : UIViewController {
    
    @IBAction func deleteAccountButtonClicked(sender: AnyObject) {
        let user = FIRAuth.auth()?.currentUser
        user?.deleteWithCompletion { error in
            if let error = error {
                NSLog(error.localizedDescription)
                return
            } else {
                let defaults = NSUserDefaults.standardUserDefaults()
                defaults.removeObjectForKey("loggedInUser")
                self.performSegueWithIdentifier("settingsToMainMenuSegue", sender: self)
            }
        }
    }

    @IBAction func setSoundChecker(sender: AnyObject) {
        ms.setSoundBool()
    }
   
    
}