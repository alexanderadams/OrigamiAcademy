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
        
        for instruction in managedList! {
            if FIRAuth.auth()?.currentUser?.email == instruction.valueForKey("author") as? String {
                instructionList.addObject(instruction)
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
            cell.creationButton.titleLabel?.text = "Edit"
        }
        else {
            // Firebase stuff here
            
            cell.creationButton.titleLabel?.text = "Publish" // if already published, say unpublish or something
            
        }
        
        return cell
    }
    
    @IBAction func creationButton(sender: AnyObject) {
        let row = sender.tag
        let instruction = instructionList[row]
        if editor {
            ms.playSound()
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewControllerWithIdentifier("instructionCreator") as! InstructionCreatorController
            nextViewController.editInstruction = true
            nextViewController.creationName = instruction.valueForKey("creation") as! String
            self.presentViewController(nextViewController, animated:true, completion:nil)
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
}

class CreationCell: UITableViewCell {
    
    @IBOutlet weak var creationName: UILabel!
    @IBOutlet weak var creationButton: UIButton!
    
}