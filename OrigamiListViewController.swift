//
//  OrigamiListViewController.swift
//  OrigamiAcademy
//
//  Created by Cedric Charly on 10/19/16.
//  Copyright © 2016 adams. All rights reserved.
//

import UIKit
import CoreData

class OrigamiListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var instructions:[NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        instructions = retrieveInstructions()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return instructions.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("InstructionCell", forIndexPath: indexPath)
        
        let row = indexPath.row
        let instruction = instructions[row]
        
        cell.textLabel?.text = "\(instruction.valueForKey("creation")!)"
        cell.detailTextLabel?.text = "\(instruction.valueForKey("author")!)"
        
        return cell
    }
    
    func retrieveInstructions() -> [NSManagedObject] {
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
        
        return instructionsList!
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        ms.playSound()
        if let destination = segue.destinationViewController as? InstructionDetailViewController,
            dataIndex = tableView.indexPathForSelectedRow?.row {
            let instruction = instructions[dataIndex]
            destination.creation = "\(instruction.valueForKey("creation")!)"
            destination.author = "\(instruction.valueForKey("author")!)"
            destination.summary = "\(instruction.valueForKey("summary")!)"
        }
    }

}
