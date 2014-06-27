//
//  TransitionManager.swift
//  BetterNotes
//
//  The transition animation is inspired by Amornchai Kanokpullwad 's  ZFModalTransitionAnimator
//  Ian Fox on 6/11/14.
//  Copyright (c) 2014 Robo Computers. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore
import CoreGraphics


class TransitionManager : UIPercentDrivenInteractiveTransition, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate
{
    var isDismiss : Bool = false
    var isInteractive : Bool = false
    var scaleDownRatio : CGFloat = 0.9
    init() {
    }
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning!) -> NSTimeInterval
    {
        return 0.8
    }
    func animateTransition(transitionContext: UIViewControllerContextTransitioning!)
    {
        var fromVC : UIViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
        var toVC : UIViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
        
        if (!self.isDismiss) {
            
            transitionContext.containerView().addSubview(toVC.view)
            let deviceScreen = CGRectGetWidth(toVC.view.frame)
            let starRect : CGRect = CGRectMake(0, CGRectGetHeight(toVC.view.frame), CGRectGetWidth(toVC.view.frame), CGRectGetHeight(toVC.view.frame))
            toVC.view.frame = starRect;
            UIView.animateWithDuration(
                self.transitionDuration(transitionContext),
                delay: 0, usingSpringWithDamping: 5, initialSpringVelocity: 0,
                options: UIViewAnimationOptions.CurveEaseOut,
                animations: {
                    fromVC.view.transform = CGAffineTransformMakeScale(self.scaleDownRatio, self.scaleDownRatio)
                    println(CGRectGetWidth(toVC.view.frame))
                    toVC.view.frame = CGRectMake(0, 0, CGRectGetWidth(toVC.view.frame), CGRectGetHeight(toVC.view.frame))
                }, completion: {
                    (value: Bool) in
                                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
                })

        } else {

            transitionContext.containerView().bringSubviewToFront(fromVC.view)
            toVC.view.layer.transform = CATransform3DMakeScale(self.scaleDownRatio, self.scaleDownRatio, 1);

            let endRect : CGRect = CGRectMake(0, CGRectGetHeight(fromVC.view.frame),CGRectGetWidth(fromVC.view.frame), CGRectGetHeight(fromVC.view.frame))
            UIView.animateWithDuration(self.transitionDuration(transitionContext), delay: 0, usingSpringWithDamping: 5, initialSpringVelocity: 15,
                options: UIViewAnimationOptions.CurveEaseOut,
                animations: {
                    toVC.view.layer.transform = CATransform3DIdentity
                    fromVC.view.frame = endRect
           
                }, completion: {
                    (value: Bool) in
                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
                    
            })
        }

        
    }
    func animationControllerForPresentedController(presented: UIViewController!, presentingController presenting: UIViewController!, sourceController source: UIViewController!) -> UIViewControllerAnimatedTransitioning!
    {
        

        self.isDismiss = false
        return self
    }
    func animationControllerForDismissedController(dismissed: UIViewController!) -> UIViewControllerAnimatedTransitioning!
    {
        self.isDismiss = true
        return self
    }
    func interactionControllerForDismissal(animator : UIViewControllerAnimatedTransitioning!) ->UIViewControllerAnimatedTransitioning!
    {

        return nil
    }
    func interactionControllerForPresentation(animator : UIViewControllerAnimatedTransitioning!) ->
        UIViewControllerAnimatedTransitioning!
    {
        return nil
    }
}

