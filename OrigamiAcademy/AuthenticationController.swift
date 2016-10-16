//
//  AuthenticationController.swift
//  OrigamiAcademy
//
//  Created by Christiano Contreras on 10/16/16.
//  Copyright © 2016 adams. All rights reserved.
//

import UIKit

class AuthenticationController: UIViewController {

    @IBOutlet weak var loginRegisterLabel: UILabel!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginRegisterButton: UIButton!
    
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
}
