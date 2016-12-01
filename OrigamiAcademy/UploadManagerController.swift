//
//  UploadManagerController.swift
//  OrigamiAcademy
//
//  Created by Alexander Adams on 10/27/16.
//  Copyright © 2016 adams. All rights reserved.
//

import UIKit
import CoreData

import Firebase

class UploadManagerController : UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var editor:Bool = false
    var instructionList: NSMutableOrderedSet = []
    
    @IBOutlet weak var instructionTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        instructionTable.delegate = self
        instructionTable.dataSource = self
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName:"Instruction")
        var managedList:[NSManagedObject]? = nil
        
        do {
            try managedList = managedContext.executeFetchRequest(fetchRequest) as? [NSManagedObject]
        } catch {
            let nserror = error as NSError
            NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
            abort()
        }
        
        for (index, instruction) in managedList!.enumerate() {
            if FIRAuth.auth()?.currentUser?.email == instruction.valueForKey("author") as? String {
                instructionList.addObject(instruction)
            }
            if instruction.valueForKey("creation") as! String == "badObject" {
                managedList?.removeAtIndex(index)
                managedContext.deleteObject(instruction)
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
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return instructionList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CreationCell", forIndexPath: indexPath) as! CreationCell
        
        let row = indexPath.row
        let instruction = instructionList[row]
        
        cell.creationName.text = instruction.valueForKey("creation") as? String
        cell.creationButton.tag = row
        
        if editor {
            cell.creationButton.setTitle("Edit", forState: .Normal)
        }
        else {
            // Firebase stuff here
            
            cell.creationButton.setTitle("Publish", forState: .Normal) // if already published, say unpublish or something
            
        }
        
        return cell
    }
    
    @IBAction func creationButton(sender: AnyObject) {
        let row = sender.tag
        let _ = instructionList[row]
        if editor {
            ms.playSound()
            performSegueWithIdentifier("editorSegue", sender: sender)
        }
        else {
            // Publish/Unpublish the instructions
        }
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        if editor {
            return true
        }
        return false
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        ms.playSound()
        if let destination = segue.destinationViewController as? InstructionCreatorController {
            let row = sender!.tag
            let instruction = instructionList[row] as? NSObject
            destination.editInstruction = true
            destination.creationName = (instruction!.valueForKey("creation") as? String)!
        }
    }
}

class CreationCell: UITableViewCell {
    
    @IBOutlet weak var creationName: UILabel!
    @IBOutlet weak var creationButton: UIButton!
    
}