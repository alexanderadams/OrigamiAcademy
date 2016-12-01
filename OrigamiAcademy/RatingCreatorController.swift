//
//  RatingCreatorController.swift
//  OrigamiAcademy
//
//  Created by Alexander Adams on 11/19/16.
//  Copyright © 2016 adams. All rights reserved.
//

import UIKit
import CoreData
import Firebase

class RatingCreatorController: UIViewController {

    @IBOutlet weak var ratingBar: RatingsBarController!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var commentField: UITextView!
    var instructionName = String()
    var instructionUID = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(RatingCreatorController.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func submitted(sender: AnyObject) {
        let rating = ratingBar.rating
        let comment = commentField.text
        
         // Save to Firebase here
        let ref = FIRDatabase.database().reference()
        let instructionsRef = ref.child("instructions")
        let ratingsRef = ref.child("ratings")
        
        let generatedName = NSUUID().UUIDString
        NSLog("Key for Rating: \(generatedName)")
        let ratingMetadata:[String: AnyObject] = ["score": rating,
                                                       "comment": comment!]
        ratingsRef.child(generatedName).setValue(ratingMetadata)
        
        instructionsRef.child(instructionUID).child("ratings").updateChildValues([generatedName: true])
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let entity =  NSEntityDescription.entityForName("Rating", inManagedObjectContext: managedContext)
        let ratingObj = NSManagedObject(entity: entity!, insertIntoManagedObjectContext:managedContext)
        ratingObj.setValue(rating, forKey: "score")
        ratingObj.setValue(comment, forKey: "comment")
        
        let fetchRequest = NSFetchRequest(entityName:"Instruction")
        var fetchedResults:[NSManagedObject]? = nil
        do {
            try fetchedResults = managedContext.executeFetchRequest(fetchRequest) as? [NSManagedObject]
        } catch {
            let nserror = error as NSError
            NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
            abort()
        }
        var instruction:NSObject
        for (_, result) in fetchedResults!.enumerate() {
            if result.valueForKey("creation") as? String == instructionName {
                instruction = result
                ratingObj.setValue(instruction, forKey: "instruction")
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        ms.playSound()
    }
}
