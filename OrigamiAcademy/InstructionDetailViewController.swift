//
//  InstructionDetailViewController.swift
//  OrigamiAcademy
//
//  Created by Cedric Charly on 10/19/16.
//  Copyright © 2016 adams. All rights reserved.
//

import UIKit
import CoreData

class InstructionDetailViewController: UIViewController {
    
    @IBOutlet weak var creationNameLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var navTitle: UINavigationItem!
    
    var creation:String = String()
    var author:String = String()
    var summary:String = String()

    override func viewDidLoad() {
        super.viewDidLoad()
        creationNameLabel.text = "\(creation)"
        authorLabel.text = "\(author)"
        descriptionLabel.text = "\(summary)"
        navTitle.title = "\(creation)"
        
        creationNameLabel.textAlignment = NSTextAlignment.Center
        authorLabel.textAlignment = NSTextAlignment.Center
        descriptionLabel.textAlignment = NSTextAlignment.Center
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        ms.playSound()
        if let destination = segue.destinationViewController as? InstructionViewController {
            destination.instructionSet = creation
        }
    }

}
