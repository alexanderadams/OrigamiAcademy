//
//  UploadManagerController.swift
//  OrigamiAcademy
//
//  Created by Alexander Adams on 10/27/16.
//  Copyright © 2016 adams. All rights reserved.
//

import UIKit
import CoreData

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
            instructionList.addObject(instruction)
        }
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
        
        cell.textLabel?.text = String("\(instruction.valueForKey("creation")!)")
        
        let button = cell.contentView.viewWithTag(1) as? UIButton
        
        if editor {
            button?.titleLabel?.text = "Edit"
        }
        else {
            button?.titleLabel?.text = "Uploade (Not Yet Implemented)"
            
            // FINAL RELEASE STUFF
            // set cell button text to "Upload" or "Remove"
        }
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        ms.playSound()
    }
}