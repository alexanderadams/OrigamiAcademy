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
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var createInstructionsButton: UIButton!

    override func viewDidLoad() {
        // Do any additional setup after loading the view, typically from a nib.
        
        super.viewDidLoad()
        
        
        clearCoreData()
        navigationItem.hidesBackButton = true
        let curUser = FIRAuth.auth()?.currentUser
        if curUser == nil {
            backButton.hidden = false
            logoutButton.hidden = true
            createInstructionsButton.hidden = true
            FIRAuth.auth()?.signInWithEmail("origami@origamiacademy.com", password: "123456") { (curUser, error) in
                if let error = error {
                    NSLog(error.localizedDescription)
                }
                else
                {
                    if !self.instructionsInstalled(curUser!.uid)
                    {
                        self.instructionsInstaller(curUser!.uid)
                    }

                }
            }
            
        } else {
            backButton.hidden = true
            createInstructionsButton.hidden = false
            logoutButton.hidden = false
            if !instructionsInstalled(curUser!.uid)
            {
                instructionsInstaller(curUser!.uid)
            }
        }
        
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        ms.playSound()
    }
    
    
    @IBAction func back(sender: AnyObject) {
        do {
            try FIRAuth.auth()!.signOut()
        } catch _ {
            NSLog("Error signing out")
        }
        clearCoreData()
        clearImages()
        self.navigationController?.popViewControllerAnimated(true)
    }

    @IBAction func logoutButton(sender: AnyObject) {
        do {
            try FIRAuth.auth()!.signOut()
        } catch _ {
            NSLog("Error signing out")
        }
        clearCoreData()
        clearImages()
    }
    
    func instructionsInstalled(uid:String) -> Bool {
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
        
        if instructionsList?.count != 0{
            return true
        }
        
        return false
    }
    
    func instructionsInstaller(uid:String) {
        
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let managedContext = appDelegate.managedObjectContext
        
            let ref = FIRDatabase.database().reference()
            let ratingsRef = ref.child("ratings")
            ref.child("instructions").observeSingleEventOfType(.Value, withBlock: { snapshot in
            let instructions = snapshot.value as? NSDictionary
            let instructionKeys = instructions
            for instructionKey in instructionKeys!
            {
                // read in instruction information to create instruction entity
                ref.child("instructions").child((instructionKey.key as? String)!).observeSingleEventOfType(.Value, withBlock: { snapshot in
                
                // Create the entity we want to save
                let entity =  NSEntityDescription.entityForName("Instruction", inManagedObjectContext: managedContext)
                let instruction = NSManagedObject(entity: entity!, insertIntoManagedObjectContext:managedContext)
                let instructionStringKey = instructionKey.key as? String
                    
                let instructionData = snapshot.value as? NSDictionary
                
                let numOfSteps = instructionData!["numOfSteps"] as? Int
                
                    instruction.setValue(instructionData!["creation"], forKey: "creation")
                    instruction.setValue(numOfSteps, forKey: "numOfSteps")
                    instruction.setValue(instructionData!["author"], forKey: "author")
                    instruction.setValue(instructionData!["summary"], forKey: "summary")
                    instruction.setValue(instructionData!["finishedImage"], forKey: "finishedImage")
                    instruction.setValue(instructionStringKey, forKey: "uid")
                    
                    // read the steps and create the entities
                    let stepSet:NSMutableOrderedSet = []
                    ref.child("steps").child( (instructionKey.key as? String)!).observeSingleEventOfType(.Value, withBlock: { snapshot in
                        
                        let setOfSteps = snapshot.value as? NSDictionary
                        
                        for (stepKey,stepData) in setOfSteps! {
                            
                            let entity =  NSEntityDescription.entityForName("Step", inManagedObjectContext: managedContext)
                            let step = NSManagedObject(entity: entity!, insertIntoManagedObjectContext:managedContext)
                            let stepKeyString = stepKey as? String
                            
                            step.setValue(stepData["stepNumber"], forKey: "number")
                            step.setValue(stepData["details"], forKey: "details")
                            step.setValue(stepData["image"], forKey: "image")
                            step.setValue(instruction, forKey: "instruction")
                            step.setValue(stepKeyString, forKey: "uid")
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
                    
                    let ratingSet:NSMutableSet = []
                    let ratingsDict = instructionData!["ratings"] as? NSDictionary
                    
                    for (ratingsKey, _) in ratingsDict! {
                        ratingsRef.child(ratingsKey as! String).observeSingleEventOfType(.Value, withBlock: {
                        snapshot in
                            let ratingsData = snapshot.value as? NSDictionary
                            
                            let entity =  NSEntityDescription.entityForName("Rating", inManagedObjectContext: managedContext)
                            let rating = NSManagedObject(entity: entity!, insertIntoManagedObjectContext:managedContext)
                            
                            rating.setValue(ratingsData!["comment"], forKey: "comment")
                            rating.setValue(ratingsData!["score"], forKey: "score")
                            rating.setValue(instruction, forKey: "instruction")
                            ratingSet.addObject(rating)
                        })
                    }
                    instruction.setValue(ratingSet, forKey: "ratings")
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
    
    func clearImages() ->Bool
    {
        let folderPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString
        let fileManager = NSFileManager.defaultManager()
        let enumerator:NSDirectoryEnumerator = fileManager.enumeratorAtPath(folderPath as String)!
        
        while let element = enumerator.nextObject() as? String {
            if element.hasSuffix("jpg") {
                do {
                try fileManager.removeItemAtPath("\(folderPath)/\(element)")}
                catch {
                    let nserror = error as NSError
                    NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                    abort()}
            }
        }
        
        return true
    }

}