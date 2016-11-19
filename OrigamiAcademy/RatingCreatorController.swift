//
//  RatingCreatorController.swift
//  OrigamiAcademy
//
//  Created by Alexander Adams on 11/19/16.
//  Copyright © 2016 adams. All rights reserved.
//

import UIKit

class RatingCreatorController: UIViewController {

    @IBOutlet weak var ratingBar: RatingsBarController!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var comment: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(RatingCreatorController.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func submitted(sender: AnyObject) {
        _ = ratingBar.rating // When used give it a name, currently blank to supress warning
         // Save to Firebase here
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        ms.playSound()
    }
}
