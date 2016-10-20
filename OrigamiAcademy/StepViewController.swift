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
    var imageName: String = String()
    var instructions: String = String()
    var creation: String = String()
    
    @IBOutlet weak var stepImage: UIImageView!
    
    @IBOutlet weak var stepNumber: UILabel!
    @IBOutlet weak var instructionsLabel: UILabel!
    @IBOutlet weak var navSteps: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stepNumber.text = "Step \(stepIndex + 1)"
        instructionsLabel.text = instructions
        stepImage.image = UIImage(named:imageName)
        navSteps.title = "\(creation) Instructions"
    }
}