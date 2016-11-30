//
//  InstructionDetailViewController.swift
//  OrigamiAcademy
//
//  Created by Cedric Charly on 10/19/16.
//  Copyright © 2016 adams. All rights reserved.
//

import UIKit
import CoreData

class InstructionDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIPopoverPresentationControllerDelegate {
    
    @IBOutlet weak var creationNameLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var imageFrame: UIImageView!
    @IBOutlet weak var ratingTable: UITableView!
    
    var creation:String = String()
    var author:String = String()
    var summary:String = String()
    var imagePath:String = String()
    var ratings: [NSManagedObject] = []

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
        
        
        // Get ratings object for this instruction
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "CommentPopoverSegue" {
            let vc = segue.destinationViewController as? CommentPopover
            let controller = vc!.popoverPresentationController
            if controller != nil {
                controller?.delegate = self
            }
        }
        else {
            ms.playSound()
            if let destination = segue.destinationViewController as? InstructionViewController {
                destination.instructionSet = creation
            }
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ratings.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("RatingCell", forIndexPath: indexPath) as! RatingCell
        
        let row = indexPath.row
        let rating = ratings[row]
        
        cell.commentLabel.text = rating.valueForKey("comment") as? String
        cell.ratingBar.rating = rating.valueForKey("score") as! Int
        cell.ratingBar.locked = true
        cell.ratingBar.buttonSize = 20
        cell.ratingBar.buttonSpacing = 3
        
        return cell
    }
}

class RatingCell: UITableViewCell {
    @IBOutlet weak var ratingBar: RatingsBarController!
    @IBOutlet weak var commentLabel: UILabel!
    
}

class CommentPopover: UIViewController {
    @IBOutlet weak var comment: UILabel!
    
}

