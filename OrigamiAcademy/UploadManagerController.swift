//
//  UploadManagerController.swift
//  OrigamiAcademy
//
//  Created by Alexander Adams on 10/27/16.
//  Copyright © 2016 adams. All rights reserved.
//

import UIKit

class UploadManagerController : UIViewController {
    
    var editor:Bool = false
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        ms.playSound()
    }
}