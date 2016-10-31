//
//  InstructionCreatorController.swift
//  OrigamiAcademy
//
//  Created by Alexander Adams on 10/27/16.
//  Copyright © 2016 adams. All rights reserved.
//

import UIKit
import CoreData

class InstructionCreatorController : UIViewController {
    
    var editInstruction:Bool = false
    @IBOutlet weak var creationNameText: UITextField!
    @IBOutlet weak var descriptionText: UITextField!
    @IBOutlet weak var stepTable: UITableView!
    var instruction: NSObject?
    var stepList: NSOrderedSet = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if editInstruction {
            // get instruction object
            // fill in text fields with correct attributes
            // get step objects and store them in array
            // fill in step cells
        }
        else {
            // create intstrucion object
        }
    }
    
    @IBAction func saveCreation(sender: AnyObject) {
        // get instruction object
        // update creation name with the text field
        // update summary with the text field
        // update all step object names
        // attatch all step objects to the instruction object
    }
    
    @IBAction func addStep(sender: AnyObject) {
        // create step cell in table
        // create step object
    }
    
    @IBAction func removeLastStep(sender: AnyObject) {
        // get last step object
        // delete last step object
        // remove last cell in table
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        ms.playSound()
        // get selected cell
        // send step name to the step editor
    }
}