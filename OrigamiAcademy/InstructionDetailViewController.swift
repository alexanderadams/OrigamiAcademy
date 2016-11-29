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
    @IBOutlet weak var imageFrame: UIImageView!
    
    var creation:String = String()
    var author:String = String()
    var summary:String = String()
    var imagePath:String = String()

    override func viewDidLoad() {
        super.viewDidLoad()
        creationNameLabel.text = "\(creation)"
        authorLabel.text = "\(author)"
        descriptionLabel.text = "\(summary)"
        
        creationNameLabel.textAlignment = NSTextAlignment.Center
        authorLabel.textAlignment = NSTextAlignment.Center
        descriptionLabel.textAlignment = NSTextAlignment.Center
        let documentsFolder = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString
        imageFrame.image = UIImage(named: "\(documentsFolder)/\(imagePath).jpg")
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
