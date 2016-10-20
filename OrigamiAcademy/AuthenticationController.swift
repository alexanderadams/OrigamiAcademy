//
//  AuthenticationController.swift
//  OrigamiAcademy
//
//  Created by Christiano Contreras on 10/16/16.
//  Copyright © 2016 adams. All rights reserved.
//

import UIKit
import CoreData

class AuthenticationController: UIViewController {

    @IBOutlet weak var loginRegisterLabel: UILabel!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginRegisterButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    var newUser:Bool? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if newUser! {
            loginRegisterLabel.text = "Register"
            loginRegisterButton.setTitle("Register", forState: .Normal)
        } else {
            loginRegisterLabel.text = "Login"
            loginRegisterButton.setTitle("Login", forState: .Normal)
        }
        loginRegisterLabel.textAlignment = NSTextAlignment.Center
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func loginRegisterButtonClicked(sender: AnyObject) {
        ms.playSound()
        let userName:String = usernameTextField.text!
        let password:String = passwordTextField.text!
        if newUser! {
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let managedContext = appDelegate.managedObjectContext
            let entity = NSEntityDescription.entityForName("User", inManagedObjectContext: managedContext)
            let user = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
        
            user.setValue(userName, forKey: "userName")
            user.setValue(password, forKey: "password")
        
            do {
                try managedContext.save()
                self.performSegueWithIdentifier("loginRegisterSegue", sender: self)
            } catch {
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
            
        } else {
            let user = fetchUser(userName, password: password)
            if user != nil {
                let defaults = NSUserDefaults.standardUserDefaults()
                defaults.setObject(userName, forKey: "loggedInUser")
                self.performSegueWithIdentifier("loginRegisterSegue", sender: self)
            } else {
                errorLabel.hidden = false
            }
        }
    }
    
    func fetchUser(userName:String, password:String) -> NSManagedObject? {
        let fetchedResults = retrieveUsers()
        var tempUserName:String? = nil
        var tempPassword:String? = nil
        
        for user in fetchedResults {
            tempUserName = user.valueForKey("userName") as? String
            tempPassword = user.valueForKey("password") as? String
            
            if userName == tempUserName && password == tempPassword {
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
