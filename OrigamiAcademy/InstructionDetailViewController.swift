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
    
    var creation:String = String()
    var author:String = String()
    var summary:String = String()

    override func viewDidLoad() {
        super.viewDidLoad()
        creationNameLabel.text = "\(creation)"
        authorLabel.text = "\(author)"
        descriptionLabel.text = "\(summary))"
        
        creationNameLabel.textAlignment = NSTextAlignment.Center
        authorLabel.textAlignment = NSTextAlignment.Center
        descriptionLabel.textAlignment = NSTextAlignment.Center
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
