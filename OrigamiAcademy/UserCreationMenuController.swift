//
//  UserCreationMenuController.swift
//  OrigamiAcademy
//
//  Created by Alexander Adams on 10/27/16.
//  Copyright © 2016 adams. All rights reserved.
//

import UIKit

class UserCreationMenuController : UIViewController {
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        ms.playSound()
        
        if let destination = segue.destinationViewController as? UploadManagerController {
            if segue.identifier == "EditCreationSegue" {
                destination.editor = false
            }
            if segue.identifier == "ManageUploadsSegue" {
                destination.editor = false
            }
        }
    }
}