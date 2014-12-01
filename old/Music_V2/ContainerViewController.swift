//
//  ContainerViewController.swift
//  Music_V2
//
//  Created by Jaclyn May on 11/25/14.
//  Copyright (c) 2014 NYU. All rights reserved.
//

import Foundation

class ContainerViewController:UIViewController{
    let SegueIdentifierFirst = "embedFirst"
    let SegueIdentifierSecond = "embedSecond"
    var currentSegueIdentifier:String!
    var firstViewController:FirstViewController!
    var secondViewController:EQViewController!
    var player:Player!
    
    var transitionInProgress:Bool!
    
    
    override func viewDidLoad() {
        self.transitionInProgress = false
        self.currentSegueIdentifier = self.SegueIdentifierFirst
        self.performSegueWithIdentifier(self.currentSegueIdentifier, sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        NSLog("\(__FILE__).\( __FUNCTION__)")
        // Instead of creating new VCs on each seque we want to hang on to existing
        // instances if we have it. Remove the second condition of the following
        // two if statements to get new VC instances instead.
        if (segue.identifier! == self.SegueIdentifierFirst) {
            self.firstViewController = segue.destinationViewController as FirstViewController
            self.firstViewController.player = self.player
        }
        
        if (segue.identifier == self.SegueIdentifierSecond) {
            self.secondViewController = segue.destinationViewController as EQViewController
            self.secondViewController.player = self.player

        }
        
        // If we're going to the first view controller.
        if (segue.identifier == self.SegueIdentifierFirst) {
            // If this is not the first time we're loading this.
            if (self.childViewControllers.count > 0) {
                self.swapFromViewController(self.childViewControllers[0] as UIViewController, toViewController:self.firstViewController)
            }
            else {
                // If this is the very first time we're loading this we need to do
                // an initial load and not a swap.
                self.addChildViewController(segue.destinationViewController as UIViewController)
                var destView:UIView! = segue.destinationViewController.view!
                destView.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight
                destView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
                self.view.addSubview(destView);
                segue.destinationViewController.didMoveToParentViewController(self);
            }
        }
            // By definition the second view controller will always be swapped with the
            // first one.
        else if (segue.identifier == self.SegueIdentifierSecond) {
            self.swapFromViewController(self.childViewControllers[0] as UIViewController, toViewController:self.secondViewController)
        }


        
    }
    
    func swapFromViewController(fromViewController:UIViewController, toViewController:UIViewController){
        NSLog("\(__FILE__).\( __FUNCTION__)")
        toViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        
        fromViewController.willMoveToParentViewController(nil);
        self.addChildViewController(toViewController);
        
        self.transitionFromViewController(fromViewController, toViewController:toViewController, duration:1.0, options:UIViewAnimationOptions.TransitionCrossDissolve, animations:nil, completion:{(finished:Bool) in
            fromViewController.removeFromParentViewController();
            toViewController.didMoveToParentViewController(self);
            self.transitionInProgress = false;
            });
    }
    
    func swapViewControllers(){
        NSLog("\(__FILE__).\( __FUNCTION__)")
        
        if (self.transitionInProgress != false) {
            return;
        }
        
        self.transitionInProgress = true;
        self.currentSegueIdentifier = self.currentSegueIdentifier == self.SegueIdentifierFirst ? self.SegueIdentifierSecond : self.SegueIdentifierFirst;
        
        if (self.currentSegueIdentifier == self.SegueIdentifierFirst && self.firstViewController != nil) {
            self.swapFromViewController(self.secondViewController,toViewController:self.firstViewController);
            return;
        }
        
        if ((self.currentSegueIdentifier == self.SegueIdentifierSecond) && self.secondViewController != nil) {
            self.swapFromViewController(self.firstViewController,toViewController:self.secondViewController);
            return;
        }
        
        self.performSegueWithIdentifier(self.currentSegueIdentifier,sender:nil);
        
    }

        
}
    