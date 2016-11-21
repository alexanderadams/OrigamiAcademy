//
//  ViewController.swift
//  OrigamiAcademy
//
//  Created by Alexander Adams on 10/4/16.
//  Copyright © 2016 adams. All rights reserved.
//

import UIKit
import CoreData

import Firebase

class ViewController: UIViewController {
    
    let loginSegue:String = "loginSegue"
    let newUserSegue:String = "newUserSegue"
    let notNowSegue:String = "notNowSegue"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //clearCoreData()
       
        navigationItem.hidesBackButton = true

        let curUser = FIRAuth.auth()?.currentUser
        if curUser != nil {
            self.performSegueWithIdentifier("notNowSegue", sender: self)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        ms.playSound()
        if segue.identifier == loginSegue {
            let destination = segue.destinationViewController as? AuthenticationController
            destination?.newUser = false
        } else if segue.identifier == newUserSegue {
            let destination = segue.destinationViewController as? AuthenticationController
            destination?.newUser = true
        } else if segue.identifier == notNowSegue {
            
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
}
