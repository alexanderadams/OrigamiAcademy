//
//  InstructionViewController.swift
//  OrigamiAcademy
//
//  Created by Alexander Adams on 10/16/16.
//  Copyright © 2016 adams. All rights reserved.
//

import UIKit
import CoreData

class InstructionViewController: UIPageViewController, UIPageViewControllerDataSource {
    
    private var pageViewController: UIPageViewController!
    
    var instructionSet: String = ""
    var numOfSteps: Int = 0
    var instructions: NSMutableArray = []
    var images: NSMutableArray = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        getInstructionSet()
        setViewControllers([getStepController(0)!], direction: .Forward, animated: false, completion: nil)
        dataSource = self
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        let stepController = viewController as! StepViewController
        
        if (stepController.stepIndex > 0) {
            return self.getStepController(stepController.stepIndex - 1)
        }
        
        return nil
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        let stepController = viewController as! StepViewController
        
        if (stepController.stepIndex < numOfSteps) {
            return self.getStepController(stepController.stepIndex + 1)
        }
        
        return nil
    }
    
    func getStepController(stepIndex: Int) -> UIViewController? {
        if stepIndex < numOfSteps {
            let stepController = self.storyboard!.instantiateViewControllerWithIdentifier("StepView") as! StepViewController
            stepController.stepIndex = stepIndex
            
            let stringDocumentsURL = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString

            stepController.imageName = "\(stringDocumentsURL)/\(images[stepIndex]).jpg"
    
            stepController.instructions = String(instructions[stepIndex])
            return stepController
        }
        return nil
    }
    
    func getInstructionSet() {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        var fetchRequest = NSFetchRequest(entityName:"Instruction")
        var instructionsList:[NSManagedObject]? = nil
        
        do {
            try instructionsList = managedContext.executeFetchRequest(fetchRequest) as? [NSManagedObject]
        } catch {
            // If an error occurs
            let nserror = error as NSError
            NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
            abort()
        }
        var instruction: NSManagedObject = instructionsList![0]
        for i in instructionsList! {
            if i.valueForKey("creation") as! String == self.instructionSet {
                instruction = i
            }
        }
        numOfSteps = instruction.valueForKey("numOfSteps") as! Int
        
        fetchRequest = NSFetchRequest(entityName:"Step")
        
        let steps = instruction.valueForKey("steps") as! NSOrderedSet
        
        for _ in 0...numOfSteps {
            instructions.addObject("Instructions not found")
            images.addObject("no_image")
        }
        for step in steps {
            let index = step.valueForKey("number") as! Int
            instructions.replaceObjectAtIndex(index, withObject: step.valueForKey("details") as! String)
            images.replaceObjectAtIndex(index, withObject: step.valueForKey("image") as! String)
        }
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return numOfSteps
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
}
        