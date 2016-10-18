//
//  SettingsController.swift
//  OrigamiAcademy
//
//  Created by Christiano Contreras on 10/17/16.
//  Copyright © 2016 adams. All rights reserved.
//

import Foundation
import UIKit
import CoreData
class settingsController : UIViewController {
    
    @IBAction func deleteAccountButtonClicked(sender: AnyObject) {
        let defaults = NSUserDefaults.standardUserDefaults()
        
        let userName = defaults.objectForKey("loggedInUser") as? String
        
        let user = fetchUser(userName!) as NSManagedObject?
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        managedContext.deleteObject(user!)
        defaults.removeObjectForKey("loggedInUser")
        self.performSegueWithIdentifier("settingsToMainMenuSegue", sender: self)
        
        
    }
    
    func fetchUser(userName:String) -> NSManagedObject? {
        let fetchedResults = retrieveUsers()
        var tempUserName:String? = nil
        
        for user in fetchedResults {
            tempUserName = user.valueForKey("userName") as? String
            
            if userName == tempUserName {
                return user
            }
        }
        
        return nil
    }
    
    func retrieveUsers() -> [NSManagedObject] {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "User")
        var fetchedResults:[NSManagedObject]? = nil
        
        do {
            try fetchedResults = managedContext.executeFetchRequest(fetchRequest) as? [NSManagedObject]
        } catch {
            let nserror = error as NSError
            NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
            abort()
        }
        
        return(fetchedResults)!
        
    }

   
    
}