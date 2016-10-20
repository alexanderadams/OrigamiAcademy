//
//  SoundController.swift
//  OrigamiAcademy
//
//  Created by Christiano Contreras on 10/18/16.
//  Copyright © 2016 adams. All rights reserved.
//

import Foundation
import AVFoundation

class MakeSound {
    var makeSound:Bool
    var audioPlayer:AVAudioPlayer?
    var soundHandler:NSURL
    
    init() {
        makeSound = true
        soundHandler = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("beep", ofType: "wav")!)
        do {
            audioPlayer = try AVAudioPlayer(contentsOfURL: soundHandler)
        } catch let error as NSError {
            print(error.description)
        }
    }
    
    func playSound() {
        if makeSound {
            audioPlayer!.prepareToPlay()
            audioPlayer!.play()
        }
    }
    
    func setSoundBool() {
        makeSound = !makeSound
    }
}

var ms = MakeSound()