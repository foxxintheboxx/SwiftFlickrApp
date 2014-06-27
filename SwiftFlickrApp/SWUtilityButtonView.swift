//
//  SWUtilityButtonView.swift
//  SwiftFlickrApp
//  a swift translation of Chris Wendel's
//  Created by Ian Fox on 6/18/14.
//  Copyright (c) 2014 synboo. All rights reserved.
//

import Foundation

let kUtilityButtonWidthDefault : Float = 90


class SWUtilityButtonView : UIView {
    var utilityButtonSelector : Selector?
    var parentCell : SWTitleView?
    var widthConstraint : NSLayoutConstraint?
    var _utilityButtons: UIButton[] = []
    var utilityButtons : UIButton[] {
    get {
        return _utilityButtons
    }
    set(newButtons){
        for button in _utilityButtons
        {
            button.removeFromSuperview()
        }
        _utilityButtons = newButtons
        for button in _utilityButtons
        {
            self.addSubview(button)
        }

        if (_utilityButtons.count > 0) {
            var buttonCount : Int = 0
            var precedingView : UIButton = UIButton()
            for (buttonCount = 0; buttonCount < _utilityButtons.count; buttonCount++)
            {
                let button : UIButton = _utilityButtons[buttonCount]
                if (buttonCount == 0) {
                    let dictionary : Dictionary = ["button" : button]
                    let constraint : AnyObject[]! =
                    NSLayoutConstraint.constraintsWithVisualFormat("|[button]", options: nil, metrics: nil, views: dictionary)
                    self.addConstraints(constraint)
                } else {
                    let dictionary : Dictionary = ["precedingView": precedingView, "button" : button]
                    self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("[precedingView][button(==precedingView)]", options: nil, metrics: nil, views: dictionary))
                }
                let dictionary : Dictionary = ["button" : button]
                self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[button]|", options: nil, metrics: nil, views: dictionary))
                let tapGesture : SWTapUtilityButton = SWTapUtilityButton(target : parentCell, action: utilityButtonSelector!)
                tapGesture.buttonIndex = buttonCount
                button.addGestureRecognizer(tapGesture)
                precedingView = button
            }
            let dictionary : Dictionary = ["precedingView" : precedingView]
            self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("[precedingView]|", options: nil, metrics: nil, views: dictionary))
            
        }
        if let a = self.widthConstraint {
            let value : Float = kUtilityButtonWidthDefault * Float(_utilityButtons.count)
            a.constant = value
        }
        self.setNeedsLayout()
    }
    }

    
    init(frame : CGRect!, parentCell : SWTitleView!, utilityButtonSelector : Selector!)
    {
        super.init(frame : frame)
        self.parentCell = parentCell
        self.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.widthConstraint = NSLayoutConstraint(
            item: self,
            attribute:NSLayoutAttribute.Width,
            relatedBy:NSLayoutRelation.Equal,
            toItem:nil,
            attribute:NSLayoutAttribute.NotAnAttribute,
            multiplier:1.0,
            constant:0.0)
        if let widthCon = self.widthConstraint?
        {
            widthCon.priority = 100
        }
        self.addConstraint(widthConstraint)
        self.utilityButtonSelector = utilityButtonSelector
    }
    
    func copyArray(array : AnyObject[] ) -> AnyObject[]
    {
        var returnVal : AnyObject[] = []
        for object : AnyObject in array
        {
            returnVal.append(object.copy())
        }
        return returnVal
    }
    func buttonHandler(sender : AnyObject)
    {
        println("")
    }
}

