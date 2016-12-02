//
//  InstructionDetailViewController.swift
//  OrigamiAcademy
//
//  Created by Cedric Charly on 10/19/16.
//  Copyright © 2016 adams. All rights reserved.
//

import UIKit
import CoreData

import Firebase

class InstructionDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIPopoverPresentationControllerDelegate {
    
    @IBOutlet weak var creationNameLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var imageFrame: UIImageView!
    @IBOutlet weak var ratingTable: UITableView!
    
    var creation:String = String()
    var author:String = String()
    var summary:String = String()
    var imagePath:String = String()
    var ratings: [NSManagedObject] = []
    var instructionUID = String()

    override func viewDidLoad() {
        super.viewDidLoad()
        ratingTable.delegate = self
        ratingTable.dataSource = self
        creationNameLabel.text = "\(creation)"
        authorLabel.text = "\(author)"
        descriptionLabel.text = "\(summary)"
        
        creationNameLabel.textAlignment = NSTextAlignment.Center
        authorLabel.textAlignment = NSTextAlignment.Center
        descriptionLabel.textAlignment = NSTextAlignment.Center
        let documentsFolder = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString
        imageFrame.image = UIImage(named: "\(documentsFolder)/\(imagePath).jpg")
        
        
        // Get ratings object for this instruction
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        var fetchRequest = NSFetchRequest(entityName:"Instruction")
        var instructionsList:[NSManagedObject]? = nil
        
        do {
            try instructionsList = managedContext.executeFetchRequest(fetchRequest) as? [NSManagedObject]
        } catch {
            // If an error occurs
            let nserror = error as NSError
            NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
            abort()
        }
        var instruction: NSManagedObject = instructionsList![0]
        for i in instructionsList! {
            if i.valueForKey("creation") as! String == self.creation {
                instruction = i
            }
        }
        
        fetchRequest = NSFetchRequest(entityName:"Rating")
        
        let results = instruction.valueForKey("ratings")
        
        if results != nil {
            let ratingsSet = instruction.valueForKey("ratings") as! NSMutableSet
            for r in ratingsSet {
                ratings.append(r as! NSManagedObject)
                //print(r.valueForKey("comment") as? String)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        ms.playSound()
        if let destination = segue.destinationViewController as? InstructionViewController {
            destination.instructionSet = creation
        }
        if let destination = segue.destinationViewController as? RatingCreatorController {
            destination.instructionUID = instructionUID
            destination.instructionName = creation
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ratings.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("RatingCell", forIndexPath: indexPath) as! RatingCell
        
        let row = indexPath.row
        let rating = ratings[row]
        
        cell.tag = row
        cell.commentLabel.text = rating.valueForKey("comment") as? String
        cell.ratingBar.rating = rating.valueForKey("score") as! Int
        cell.ratingBar.updateButtonSelectionStates()
        cell.ratingBar.locked = true
        cell.ratingBar.buttonSize = 20
        cell.ratingBar.buttonSpacing = 3
        
        return cell
    }
}

class RatingCell: UITableViewCell {
    @IBOutlet weak var ratingBar: RatingsBarController!
    @IBOutlet weak var commentLabel: UILabel!
    
}
