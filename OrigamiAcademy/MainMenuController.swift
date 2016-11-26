//
//  MainMenuController.swift
//  OrigamiAcademy
//
//  Created by Christiano Contreras on 10/18/16.
//  Copyright © 2016 adams. All rights reserved.
//

import UIKit
import CoreData

import Firebase

class MainMenuController : UIViewController {

    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var createInstructionsButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        navigationItem.hidesBackButton = true

        let curUser = FIRAuth.auth()?.currentUser

        if curUser == nil {
            logoutButton.hidden = true
            createInstructionsButton.hidden = true
            navigationItem.hidesBackButton = false
        } else {
            
            instructionsInstaller2(curUser!.uid)
            instructionsInstalled2(curUser!.uid)
        }
        
//        if !instructionsInstalled() {
//            instructionsInstaller()
//        }
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
                step.setValue(instruction, forKey: "instruction")
                stepSet.addObject(step)
            }
            let finalSet:NSOrderedSet = stepSet
            instruction.setValue(finalSet, forKey: "steps")
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
    
    func instructionsInstalled2(uid:String) -> Bool {
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
        
        if instructionsList != nil{
            return true
        }
        
        return false
    }
    
    func instructionsInstaller2(uid:String) {
        
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let managedContext = appDelegate.managedObjectContext
        
            let ref = FIRDatabase.database().reference()
            ref.child("users").child(uid).observeSingleEventOfType(.Value, withBlock: { snapshot in
            let userData = snapshot.value as? NSDictionary
            let instructionKeys = userData!["instructions"] as? NSDictionary
            for instructionKey in instructionKeys!
            {
                // read in instruction information to create instruction entity
                ref.child("instructions").child((instructionKey.key as? String)!).observeSingleEventOfType(.Value, withBlock: { snapshot in
                
                // Create the entity we want to save
                let entity =  NSEntityDescription.entityForName("Instruction", inManagedObjectContext: managedContext)
                let instruction = NSManagedObject(entity: entity!, insertIntoManagedObjectContext:managedContext)
                
                let instructionData = snapshot.value as? NSDictionary
                
                let numOfSteps = instructionData!["numOfSteps"] as? Int
                
                    instruction.setValue(instructionData!["creation"], forKey: "creation")
                    instruction.setValue(numOfSteps, forKey: "numOfSteps")
                    instruction.setValue(instructionData!["author"], forKey: "author")
                    instruction.setValue(instructionData!["summary"], forKey: "summary")
                    instruction.setValue(instructionData!["finishedImage"], forKey: "finishedImage")
                    
                    // read the steps and create the entities
                    let stepSet:NSMutableOrderedSet = []
                    ref.child("steps").child( (instructionKey.key as? String)!).observeSingleEventOfType(.Value, withBlock: { snapshot in
                        
                        let setOfSteps = snapshot.value as? NSDictionary
                        
                        for (_,stepData) in setOfSteps! {
                            
                            let entity =  NSEntityDescription.entityForName("Step", inManagedObjectContext: managedContext)
                            let step = NSManagedObject(entity: entity!, insertIntoManagedObjectContext:managedContext)
                            
                            step.setValue(stepData["stepNumber"], forKey: "number")
                            step.setValue(stepData["details"], forKey: "details")
                            step.setValue(stepData["image"], forKey: "image")
                            step.setValue(instruction, forKey: "instruction")
                            stepSet.addObject(step)
                            
                            // now download the image for each step
                            let storageRef = FIRStorage.storage().reference()
                            
                            let imageRef = storageRef.child("images/\(stepData["image"]).jpg")
                            
                            imageRef.downloadURLWithCompletion { (URL, error) -> Void in
                                if (error != nil) {
                                    print("something wrong with URL")
                                } else {
                                    
                                }
                            }
                            
                            let stringDocumentsURL = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString
                            
                            let stringLocalURL = "\(stringDocumentsURL)/\(stepData["image"]).jpg"
                            
                            // Download to the local filesystem
                            imageRef.dataWithMaxSize(1 * 1024 * 1024) { (data, error) -> Void in
                                if (error != nil) {
                                    // Uh-oh, an error occurred!
                                } else {
                                    NSFileManager.defaultManager().createFileAtPath(stringLocalURL, contents: data, attributes: nil)
                                }
                            }
                        }
                        let finalSet:NSOrderedSet = stepSet
                        instruction.setValue(finalSet, forKey: "steps")

                    })
                    
                })
            }

                    })
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

}