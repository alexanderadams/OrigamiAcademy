//
//  StepViewController.swift
//  OrigamiAcademy
//
//  Created by Alexander Adams on 10/16/16.
//  Copyright © 2016 adams. All rights reserved.
//

import UIKit

class StepViewController: UIViewController {
    
    var stepIndex: Int = 0
    var imageName: String = ""
    var instructions: String = ""
    
    @IBOutlet weak var stepImage: UIImageView!
    
    @IBOutlet weak var stepNumber: UILabel!
    @IBOutlet weak var instructionsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        stepNumber.text = "Step \(stepIndex + 1)"
        instructionsLabel.text = instructions
        stepImage.image = UIImage(named:imageName)
    }
}