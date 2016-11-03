//
//  MainMenuController.swift
//  OrigamiAcademy
//
//  Created by Christiano Contreras on 10/18/16.
//  Copyright © 2016 adams. All rights reserved.
//

import UIKit

import Firebase

class MainMenuController : UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        navigationItem.hidesBackButton = true
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        ms.playSound()
    }

    @IBAction func logoutButton(sender: AnyObject) {
        do {
            try FIRAuth.auth()!.signOut()
        } catch _ {
            NSLog("Error signing out")
        }
    }

}