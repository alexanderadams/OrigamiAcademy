//
//  ViewController.swift
//  OrigamiAcademy
//
//  Created by Alexander Adams on 10/4/16.
//  Copyright © 2016 adams. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    
    let loginSegue:String = "loginSegue"
    let newUserSegue:String = "newUserSegue"
    let notNowSegue:String = "notNowSegue"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if !instructionsInstalled() {
            instructionsInstaller()
        }
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

    func instructionsInstalled() -> Bool {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName:"Instruction")
        var instructionsList:[NSManagedObject]? = nil
        
        do {
            try instructionsList = managedContext.executeFetchRequest(fetchRequest) as? [NSManagedObject]
        } catch {
            // If an error occurs
            let nserror = error as NSError
            NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
            abort()
        }
        let instructionNumber = Int(NSLocalizedString("instructionNumber", tableName: "instruction_list", comment:"number of instructions"))
        
        if instructionsList?.count < instructionNumber {
            return false
        }
        else {
            for i in 1...instructionNumber! {
                let creation = NSLocalizedString("instruction\(i)", tableName: "instruction_list", comment:"instruction at index")
                if !exists(instructionsList!, creation: creation) {
                    return false
                }
            }
        }
        return true
    }
    
    func exists(list:[NSManagedObject], creation:String) -> Bool {
        for i in list {
            if i.valueForKey("creation") as! String == creation {
                return true
            }
        }
        return false
    }
    
    func instructionsInstaller() {
        
    }
}
