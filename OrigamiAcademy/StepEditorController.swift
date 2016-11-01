//
//  StepEditorController.swift
//  OrigamiAcademy
//
//  Created by Alexander Adams on 10/27/16.
//  Copyright © 2016 adams. All rights reserved.
//

import UIKit
import CoreData

class StepEditorController : UIViewController {
    
    var stepNumber:Int = 0
    var stepObject:NSObject?
    
    @IBOutlet weak var stepName: UILabel!
    @IBOutlet weak var instructionText: UITextField!
    @IBOutlet weak var image: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // get step object
        
        // fill in text fields with correct attributes
        stepName.text = "Step \(stepNumber)"
    }
    
    @IBAction func saveStep(sender: AnyObject) {
        // update step object attributes
        // save step object
    }
    
    @IBAction func uploadImage(sender: AnyObject) {
        // upload image somehow
        // save image in assets (possibly over previous image)
        // save image filename to step object
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        ms.playSound()
    }
}
