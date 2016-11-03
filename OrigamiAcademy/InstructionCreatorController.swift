//
//  InstructionCreatorController.swift
//  OrigamiAcademy
//
//  Created by Alexander Adams on 10/27/16.
//  Copyright © 2016 adams. All rights reserved.
//

import UIKit
import CoreData

import Firebase

class InstructionCreatorController : UIViewController, UITableViewDataSource, UITableViewDelegate   {
    
    var editInstruction:Bool = false
    var creationName:String = String()
    @IBOutlet weak var creationNameText: UITextField!
    @IBOutlet weak var descriptionText: UITextField!
    @IBOutlet weak var stepTable: UITableView!
    var instruction: NSObject?
    var stepList: NSMutableOrderedSet = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stepTable.delegate = self
        stepTable.dataSource = self
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        if editInstruction {
            // get instruction object
            let fetchRequest = NSFetchRequest(entityName:"Instruction")
            var fetchedResults:[NSManagedObject]? = nil
            do {
                try fetchedResults = managedContext.executeFetchRequest(fetchRequest) as? [NSManagedObject]
            } catch {
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
            instruction = fetchedResults![1]
            for (_, result) in fetchedResults!.enumerate() {
                if result.valueForKey("creation") as? String == creationName {
                    instruction = result
                }
            }
            // fill in text fields with correct attributes
            creationNameText.text = creationName
            descriptionText.text = instruction?.valueForKey("summary") as? String
            // get step objects and store them in array
            stepList = instruction!.valueForKey("steps") as! NSMutableOrderedSet
        }
        else {
            // create instrucion object
            var entity =  NSEntityDescription.entityForName("Instruction", inManagedObjectContext: managedContext)
            instruction = NSManagedObject(entity: entity!, insertIntoManagedObjectContext:managedContext)
            
            // create first step
            entity =  NSEntityDescription.entityForName("Step", inManagedObjectContext: managedContext)
            let step = NSManagedObject(entity: entity!, insertIntoManagedObjectContext:managedContext)
            step.setValue(1, forKey: "number")
            step.setValue(instruction, forKey: "instruction")
            step.setValue("no_image", forKey: "image")
            stepList.addObject(step)
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stepList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("StepCell", forIndexPath: indexPath)
        
        let row = indexPath.row
        let step = stepList[row]
        cell.textLabel?.text = String("Step \(step.valueForKey("number")!)")
        
        return cell
    }
    
    @IBAction func saveCreation(sender: AnyObject) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext

        instruction?.setValue(creationNameText.text, forKey: "creation")
        instruction?.setValue(descriptionText.text, forKey: "summary")
        instruction?.setValue(stepList.count, forKey: "numOfSteps")
        let curUser = FIRAuth.auth()?.currentUser?.email
        instruction?.setValue(curUser, forKey: "author")
        let lastStep = stepList.lastObject as? NSObject
        instruction!.setValue(lastStep?.valueForKey("image"), forKey: "finishedImage")
        
        do {
            try managedContext.save()
        } catch {
            let nserror = error as NSError
            NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
            abort()
        }
    }
    
    @IBAction func addStep(sender: AnyObject) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        // create step object
        let entity =  NSEntityDescription.entityForName("Step", inManagedObjectContext: managedContext)
        let step = NSManagedObject(entity: entity!, insertIntoManagedObjectContext:managedContext)
        step.setValue(stepList.count + 1, forKey: "number")
        step.setValue(instruction, forKey: "instruction")
        step.setValue("no_image", forKey: "image")
        stepList.addObject(step)
        
        // create step cell in table
        stepTable.beginUpdates()
        var index = 0
        if stepList.count > 0 {
            index = stepList.count-1
        }
        stepTable.insertRowsAtIndexPaths([NSIndexPath(forRow: index, inSection: 0)], withRowAnimation: .Automatic)
        stepTable.endUpdates()
    }
    
    @IBAction func removeLastStep(sender: AnyObject) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        // get last step object
        let step = stepList[stepList.count - 1]
        stepList.removeObjectAtIndex(stepList.count - 1)
        
        // delete last step object
        managedContext.deleteObject(step as! NSManagedObject)
        
        // remove last cell in table
        stepTable.deleteRowsAtIndexPaths([NSIndexPath(forRow: stepTable.numberOfRowsInSection(0) - 1, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Automatic)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        ms.playSound()
        if  let destination = segue.destinationViewController as? StepEditorController,
            dataIndex = stepTable.indexPathForSelectedRow?.row
        {
            let step = stepList[dataIndex]
            destination.stepNumber = step.valueForKey("number") as! Int
            destination.stepObject = step as? NSObject
        }
    }
}