//
//  StepEditorController.swift
//  OrigamiAcademy
//
//  Created by Alexander Adams on 10/27/16.
//  Copyright © 2016 adams. All rights reserved.
//

import UIKit
import CoreData

import Firebase

class StepEditorController : UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var stepNumber:Int = 0
    var stepObject:NSObject?
    var imageName:String = String()
    let imagePicker = UIImagePickerController()
    
    @IBOutlet weak var stepName: UILabel!
    @IBOutlet weak var instructionText: UITextField!
    @IBOutlet weak var image: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        // fill in text fields with correct attributes
        stepName.text = "Step \(stepNumber)"
        instructionText.text = stepObject?.valueForKey("details") as? String
        imageName = stepObject!.valueForKey("image") as! String
        let stringDocumentsURL = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString
        
        image.image = UIImage(named: "\(stringDocumentsURL)/\(imageName).jpg")
    }
    
    @IBAction func saveStep(sender: AnyObject) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        // update step object attributes
        stepObject?.setValue(instructionText.text, forKey: "details")
        stepObject?.setValue(imageName, forKey: "image")
        
        // save step object
        do {
            try managedContext.save()
        } catch {
            let nserror = error as NSError
            NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
            abort()
        }
    }
    
    @IBAction func uploadImage(sender: AnyObject) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .PhotoLibrary
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            image.contentMode = .ScaleAspectFit

            // Generate UUID name for picked file
            let generatedName = NSUUID().UUIDString
            NSLog("image name: \(generatedName)")
            imageName = generatedName

            // Save image to cache area as JPEG
            let jpegImageBytes = UIImageJPEGRepresentation(pickedImage, 0.4)
            let StringDocumentURL = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString
            let stringLocalURL = "\(StringDocumentURL)/\(imageName).jpg"
            let success = NSFileManager.defaultManager().createFileAtPath(stringLocalURL, contents: jpegImageBytes, attributes: nil)

            if success == false {
                NSLog("Failed to save file")
            }

            // Upload image to Firebase
            let storageRef = FIRStorage.storage().reference()
            let imageRef = storageRef.child("images/\(imageName).jpg")
            let fileURL = NSURL(fileURLWithPath: stringLocalURL)
            let _ = imageRef.putFile(fileURL, metadata: nil) { metadata, error in
                if (error != nil) {
                    NSLog(error!.localizedDescription)
                } else {
                    NSLog("Uploaded file to Firebase: \(metadata!.downloadURL()?.absoluteString)")
                }
            }

            image.image = pickedImage
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        ms.playSound()
    }
}
