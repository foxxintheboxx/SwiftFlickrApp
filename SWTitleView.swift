//
//  SWTitleView.swift
//  SwiftFlickrApp
//  The SWTitleView is heavily inspired by Chris Wendel's SWTableViewCell and adapted to uiviews in general
//  Created by Ian Fox on 6/18/14.
//  Copyright (c) 2014 synboo. All rights reserved.
//

import Foundation
let viewHeight : CGFloat = 45
let viewWidth : CGFloat = 260
let kCenterVal : CGFloat = 150
let frameInit : CGRect = CGRectMake(0, 0, viewWidth, viewHeight)//swift xcode was bugging out so I had to explicitly reassign the frame
let contentFrame : CGRect = CGRectMake(kCenterVal, 0, viewWidth, viewHeight)
let contentSize : CGFloat = 420

enum SWCellState
{
    case kCenter
    case kLeft
    case kRight
}
protocol SWTitleViewProtocol
{
    func swipeableUIView(view : UIView!, didTriggerLeftUtilityButtonWithIndex index: Int)
    func swipeableUIView(view : UIView!, scrollingStateTo state: SWCellState)
    func swipeableUIView(view : UIView!, canScrollToState state: SWCellState) ->Bool
}
class SWTitleView : UIView, UIScrollViewDelegate
{
    var leftUtilityButton : UIButton[]?
    var delegate : SWTitleViewProtocol!
    var scrollView : UIScrollView = UIScrollView(frame : frameInit)
    var titleLabel : UILabel = UILabel(frame : frameInit)
    var contentView : UIView = UIView(frame : contentFrame)
    var clipView : UIView = UIView(frame : frameInit)
    var buttonView : SWUtilityButtonView?
    var leftUtitlityClipConstraint : NSLayoutConstraint?
    var cellState : SWCellState = .kCenter
    var buttonArray : UIButton[] = []
    let utilButtonWidth : CGFloat = kCenterVal
    
    
    init(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder)
        scrollView.delegate = self
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.scrollEnabled = true
        scrollView.scrollsToTop = false
        scrollView.setTranslatesAutoresizingMaskIntoConstraints(false)
        scrollView.contentSize = CGSizeMake(contentSize,0)
        scrollView.contentOffset.x = kCenterVal
        scrollView.backgroundColor = UIColorFromRGB(0x2E2E2E)

        self.frame = frameInit
        
        self.addSubview(scrollView)
        self.addConstraints([
            NSLayoutConstraint(item: self.scrollView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: self.scrollView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: self.scrollView, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: self.scrollView, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: 0.0)
            ])
        
        //create label for title view
        titleLabel.textAlignment  = NSTextAlignment.Center
        titleLabel.textColor = UIColor.whiteColor()
        //add the label to the contentview
        contentView.addSubview(titleLabel)
        //add the contentView to scrollView
        scrollView.addSubview(contentView)

        

        leftUtitlityClipConstraint = NSLayoutConstraint(item: clipView, attribute : NSLayoutAttribute.Right, relatedBy : NSLayoutRelation.Equal,
            toItem : self, attribute : NSLayoutAttribute.Left, multiplier:1.0, constant:0.0)
        let selector : Selector = "buttonHandler:"
        buttonView = SWUtilityButtonView(frame: CGRectZero, parentCell: self, utilityButtonSelector: selector)


        clipView.setTranslatesAutoresizingMaskIntoConstraints(false)
        clipView.clipsToBounds = true
        self.addSubview(clipView)

        self.addConstraints([
            NSLayoutConstraint(item: self.clipView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: self.clipView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: self.clipView, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: 0.0),
            self.leftUtitlityClipConstraint!])

        clipView.addSubview(buttonView)
        
        self.addConstraints([
            NSLayoutConstraint(item: buttonView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: clipView, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: buttonView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: clipView, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: buttonView, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: clipView, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: buttonView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.LessThanOrEqual, toItem: contentView, attribute: NSLayoutAttribute.Width, multiplier: 1.0, constant: -kUtilityButtonWidthDefault)
            ])
        if let buttonView = buttonView?
        {
            createButtons()
            buttonView.utilityButtons = buttonArray
        }
        
        
    }
    
    func createButtons() {
        var button0 : UIButton = UIButton(frame : CGRectMake(0,0, 50, 45))
        button0.backgroundColor = UIColorFromRGB(0xb1a1c6)
        button0.setImage(UIImage(named: "list.png"), forState : UIControlState.Normal)
        var button1 : UIButton = UIButton(frame : CGRectMake(50, 0, 50, 45))
        button1.backgroundColor = UIColorFromRGB(0xFF0000)
        button1.setImage(UIImage(named: "cross.png"), forState : UIControlState.Normal)
        var button2 : UIButton = UIButton(frame : CGRectMake(100, 0, 50, 45))
        button2.backgroundColor = UIColorFromRGB(0x7FB2EE)
        button2.setImage(UIImage(named: "clock.png"), forState : UIControlState.Normal)
        buttonArray.append(button0); buttonArray.append(button2); buttonArray.append(button1)
    }
    func addButtonsToSelf() {
        for button in buttonArray
        {
            self.addSubview(button)
        }
    }
    
    //MARK : ScrollView Delegate

    func scrollViewWillEndDragging(scrollView: UIScrollView!, withVelocity velocity: CGPoint, targetContentOffset: CMutablePointer<CGPoint>)
    {
        let leftThreshold : CGFloat = self.getCellStateVal(.kLeft) + (utilButtonWidth / 2)
        if (velocity.x > 0.0) || (leftThreshold < UnsafePointer<CGPoint>(targetContentOffset).memory.x) {
            cellState = .kCenter
        } else if (velocity.x < 0.5) || ((leftThreshold >= UnsafePointer<CGPoint>(targetContentOffset).memory.x) )  {
            cellState = .kLeft
        }
        UnsafePointer<CGPoint>(targetContentOffset).memory.x = getCellStateVal(cellState)

    }
    
    

    
    func getCellStateVal(cellState : SWCellState) -> CGFloat{
        var newPosition : CGFloat = 0.0
        if(cellState == .kCenter){
            newPosition = kCenterVal
        }
        return newPosition
        
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView!)
    {
        
        if let superV = contentView.superview
        {
            var frame : CGRect = superV.convertRect(contentView.frame, fromView: self)
            frame.size.width = CGRectGetWidth(self.frame)
            if let clip = leftUtitlityClipConstraint?
            {
                println("frame of content view \(CGRectGetMinX(frame))")
                println("self.frame of content view \(CGRectGetMinX(self.frame))")
                clip.constant = max(0, (kCenterVal*2) - CGRectGetMinX(frame))
                //println(clip.constant)
            }
        }
        

    }
    func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    func buttonHandler(sender : AnyObject)
    {
        println("")
    }
    
    
    
    
}