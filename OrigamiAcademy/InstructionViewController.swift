//
//  InstructionViewController.swift
//  OrigamiAcademy
//
//  Created by Alexander Adams on 10/16/16.
//  Copyright © 2016 adams. All rights reserved.
//

import UIKit
import CoreData

class InstructionViewController: UIViewController, UIPageViewControllerDataSource {
    
    private var pageViewController: UIPageViewController?
    
    var instructionSet: String = ""
    var numOfSteps: Int = 0
    var instructions: [String] = []
    var images: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        getInstructionSet()
    }

    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        return nil
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        return nil
    }
    
    func getInstructionSet() {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName:"Instruction")
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
        let steps = instruction.mutableSetValueForKey("steps")
        
        let sortdescriptor = NSSortDescriptor(key: "number", ascending: true)
        let stepsSorted = steps.sortedArrayUsingDescriptors([sortdescriptor])
        
        for step in stepsSorted {
            instructions.append(step.valueForKey("details") as! String)
            images.append(step.valueForKey("image") as! String)
        }
    }
}
        