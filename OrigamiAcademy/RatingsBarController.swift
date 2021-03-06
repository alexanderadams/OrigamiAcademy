//
//  RatingsBarController.swift
//  OrigamiAcademy
//
//  Created by Alexander Adams on 11/15/16.
//  Copyright © 2016 adams. All rights reserved.
//

import UIKit

class RatingsBarController: UIView {
    
    var rating:Int = 0
    var ratingButtons = [UIButton]()
    var buttonSize = 40
    var buttonSpacing = 5
    var locked:Bool = false
    

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        let emptyStar = UIImage(named: "empty_star")
        let filledStar = UIImage(named: "filled_star")
        
        for index in 0..<5 {
            let button = UIButton(frame: CGRect(x: 0, y: 0, width: buttonSize, height: buttonSize))
            button.setImage(emptyStar, forState: .Normal)
            button.setImage(filledStar, forState: .Selected)
            button.setImage(filledStar, forState: [.Highlighted, .Selected])
            button.adjustsImageWhenHighlighted = false
            button.addTarget(self, action: #selector(RatingsBarController.ratingButtonTapped(_:)), forControlEvents: .TouchDown)
            button.selected = index < rating
            ratingButtons += [button]
            addSubview(button)
        }
    }
    
    override func intrinsicContentSize() -> CGSize {
        return CGSize(width: buttonSize + 4*(buttonSize + buttonSpacing), height: buttonSize)
    }
    
    override func layoutSubviews() {
        var buttonFrame = CGRect(x: 0, y: 0, width: buttonSize, height: buttonSize)
        
        for (index, button) in ratingButtons.enumerate() {
            buttonFrame.origin.x = CGFloat(index * (buttonSize + buttonSpacing))
            button.frame = buttonFrame
        }
    }
    
    func ratingButtonTapped(button: UIButton) {
        if !locked {
            rating = ratingButtons.indexOf(button)! + 1
            updateButtonSelectionStates()
        }
    }
    
    func updateButtonSelectionStates() {
        for (index, button) in ratingButtons.enumerate() {
            button.selected = index < rating
        }
    }

}
