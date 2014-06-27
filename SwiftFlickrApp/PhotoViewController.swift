//
//  PhotoViewController.swift
//  SwiftFlickrApp
//
//  Created by synboo on 6/5/14.
//  Copyright (c) 2014 synboo. All rights reserved.
//

import UIKit
let photoFrame : CGRect = CGRectMake(30, 65, 260, 45)
let selfFrame : CGRect = CGRectMake(0, 0, 320, 480)
class PhotoViewController: UIViewController, UIGestureRecognizerDelegate {
    
    var photoInfo : Dictionary<String, String>!
    var shouldExit : Bool = true;
    let overLayView : UIView = UIView(frame : selfFrame)
    @IBOutlet var photoImageView : UIImageView
    @IBOutlet var titleView : SWTitleView = nil

    
    
    
    
    init(coder aDecoder: NSCoder!)
    {
        super.init(coder: aDecoder)
        //self.overLayView = UIView(frame: self.view.frame)
        //self.overLayView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        //self.view.addSubview(overLayView)
        //self.photoInfo = ["title" : ""]
    }

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.photoImageView.frame = photoFrame
        self.overLayView.backgroundColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 0.5)
        self.view.addSubview(self.overLayView)
        self.photoImageView.setImageWithURLRequest(NSURLRequest(URL: NSURL.URLWithString(self.photoInfo["url_z"])), placeholderImage: nil, success: {(request : NSURLRequest!, response : NSHTTPURLResponse!, img : UIImage! ) in
            self.photoImageView.image = img
          
            }, failure: nil);
        self.titleView.titleLabel.text = self.photoInfo["title"]
        let tap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "tapped:");
        self.view.addGestureRecognizer(tap)
 
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        
        UIView.animateWithDuration(1.5, animations: {
            self.overLayView.alpha = 1
            })
    }

    func foo(request : NSURLRequest!, response : NSHTTPURLResponse!, error : NSError!) {
    
    }
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    func tapped(gestureRecognizer: UIGestureRecognizer)
    {
        if (shouldExit) {
            self.dismissModalViewControllerAnimated(true)
        } else {
            self.titleView.hidden = !self.titleView.hidden

        }
    }
    
    override func touchesBegan(touches: NSSet!, withEvent event: UIEvent!)
    {

        let touch : AnyObject = touches.anyObject()
        let location : CGPoint = touch.locationInView(self.view)
        if (CGRectContainsPoint(self.photoImageView.frame, location))
        {
            shouldExit = false
        } else {
            shouldExit = true
        }

    }
    
    func buttonHandler(sender : AnyObject)
    {
        println("")
    }

}
