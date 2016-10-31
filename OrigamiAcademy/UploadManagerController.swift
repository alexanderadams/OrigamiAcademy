//
//  UploadManagerController.swift
//  OrigamiAcademy
//
//  Created by Alexander Adams on 10/27/16.
//  Copyright © 2016 adams. All rights reserved.
//

import UIKit
import CoreData

class UploadManagerController : UIViewController {
    
    var editor:Bool = false
    var instructionList: NSOrderedSet = []
    @IBOutlet weak var instructionTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // get instruction objects
        // fill in cells with instruction information
    }
    
    @IBAction func cellButton(sender: AnyObject) {
        if editor {
            // segue to instruction editor
            // pass instruction name
            // set editInstruction to true
        }
        else {
            // FINAL RELEASE STUFF
            // upload/remove from uploads
        }
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        ms.playSound()
    }
}