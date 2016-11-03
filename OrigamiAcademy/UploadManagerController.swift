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
        let cell = tableView.dequeueReusableCellWithIdentifier("CreationCell", forIndexPath: indexPath)
        
        let row = indexPath.row
        let instruction = instructionList[row]
        
        cell.textLabel?.text = instruction.valueForKey("creation") as? String
        
        if editor {
            cell.detailTextLabel!.text = "Edit"
        }
        else {
            cell.detailTextLabel!.text = "Upload (Not Yet Implemented)"
            
            // FINAL RELEASE STUFF
            // set cell button text to "Upload" or "Remove"
        }
        
        return cell
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        if editor {
            return true
        }
        return false
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        ms.playSound()
        if let destination = segue.destinationViewController as? InstructionCreatorController,
            dataIndex = instructionTable.indexPathForSelectedRow?.row {
            destination.editInstruction = true
            let instruction = instructionList[dataIndex] as? NSObject
            destination.creationName = (instruction!.valueForKey("creation") as? String)!
        }
    }
}