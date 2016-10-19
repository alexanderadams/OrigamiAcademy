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
        //clearCoreData()
        if !instructionsInstalled() {
            instructionsInstaller()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        ms.playSound()
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
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let instructionNumber = Int(NSLocalizedString("instructionNumber", tableName: "instruction_list", comment:"number of instructions"))
        for i in 1...instructionNumber! {
            // Create the entity we want to save
            let entity =  NSEntityDescription.entityForName("Instruction", inManagedObjectContext: managedContext)
            let instruction = NSManagedObject(entity: entity!, insertIntoManagedObjectContext:managedContext)
            
            // Set the attribute values
            let creation = NSLocalizedString("instruction\(i)", tableName: "instruction_list", comment:"creation name")
            instruction.setValue(creation, forKey: "creation")
            let stepNumber = Int(NSLocalizedString("stepNumber", tableName: "\(creation)_instructions", comment:"number of steps"))
            instruction.setValue(stepNumber, forKey: "numOfSteps")
            let author = NSLocalizedString("author", tableName: "\(creation)_instructions", comment: "author name")
            instruction.setValue(author, forKey: "author")
            let summary = NSLocalizedString("description", tableName: "\(creation)_instructions", comment: "creation description")
            instruction.setValue(summary, forKey: "summary")
            instruction.setValue("\(creation)_step\(stepNumber)", forKey: "finishedImage")
            
            // Create the instruction steps
            let stepSet:NSMutableOrderedSet = []
            for s in 1...stepNumber! {
                let entity =  NSEntityDescription.entityForName("Step", inManagedObjectContext: managedContext)
                let step = NSManagedObject(entity: entity!, insertIntoManagedObjectContext:managedContext)
                
                step.setValue(s, forKey: "number")
                let details = NSLocalizedString("step\(s)", tableName: "\(creation)_instructions", comment:"step detail")
                step.setValue(details, forKey: "details")
                step.setValue("\(creation)_step\(s)", forKey: "image")
                stepSet.addObject(step)
            }
            instruction.setValue(stepSet, forKey: "steps")
        }
        
        // Commit the changes
        do {
            try managedContext.save()
        } catch {
            // If an error occurs
            let nserror = error as NSError
            NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
            abort()
        }
    }
    
    func clearCoreData() {
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        var fetchRequest = NSFetchRequest(entityName: "Instruction")
        var fetchedResults:[NSManagedObject]
        
        do {
            try fetchedResults = managedContext.executeFetchRequest(fetchRequest) as! [NSManagedObject]
            
            if fetchedResults.count > 0 {
                
                for result:AnyObject in fetchedResults {
                    managedContext.deleteObject(result as! NSManagedObject)
                }
            }
            try managedContext.save()
            
        } catch {
            // If an error occurs
            let nserror = error as NSError
            NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
            abort()
        }
        
        fetchRequest = NSFetchRequest(entityName: "Step")
        
        do {
            try fetchedResults = managedContext.executeFetchRequest(fetchRequest) as! [NSManagedObject]
            
            if fetchedResults.count > 0 {
                
                for result:AnyObject in fetchedResults {
                    managedContext.deleteObject(result as! NSManagedObject)
                }
            }
            try managedContext.save()
            
        } catch {
            // If an error occurs
            let nserror = error as NSError
            NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
            abort()
        }
    }
}
