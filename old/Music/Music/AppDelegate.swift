//
//  AppDelegate.swift
//  AH.FM
//
//  Created by Jaclyn May on 10/23/14.
//  Copyright (c) 2014 NYU. All rights reserved.
//

import UIKit
import AVFoundation

func delay(delay:Double, closure:()->()) {
    dispatch_after(
        dispatch_time(
            DISPATCH_TIME_NOW,
            Int64(delay * Double(NSEC_PER_SEC))
        ),
        dispatch_get_main_queue(), closure)
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var timer : NSTimer?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        // Turn on remote control event delivery
//        UIApplication.sharedApplication().beginReceivingRemoteControlEvents()
//        // Set itself as first responder
//        self.becomeFirstResponder()
        AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryAmbient, withOptions: nil, error: nil)
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
        println("bp in \(__FUNCTION__)")
        return; // comment out to perform timer experiment
        
        self.timer?.invalidate()
        self.timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "fired:", userInfo: nil, repeats: true)
    }
    
    // timer fires while we are in background, provided
    // (1) we scheduled it before going into the background
    // (2) we are running in the background (i.e. playing)
    func fired(timer:NSTimer) {
        println("bp timer fired")
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        println("bp in \(__FUNCTION__)")
        println("bp state while entering background: \(application.applicationState.rawValue)")
        return; // comment out to experiment with background app performing immediate local notification
        
        delay(2) {
            println("bp trying to fire local notification")
            let ln = UILocalNotification()
            ln.alertBody = "Testing"
            application.presentLocalNotificationNow(ln)
        }
    }
    
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        println("bp got local notification reading \(notification.alertBody)")
    }
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        println("bp in \(__FUNCTION__)")
    }
    
    // we are a player app, we activate playback category only when we actually start playing
    // the rest of the time we use ambient just so we have an active category
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        println("bp in \(__FUNCTION__)")
        
        let types : UIUserNotificationType = .Alert
        let settings = UIUserNotificationSettings(forTypes: types, categories: nil)
        application.registerUserNotificationSettings(settings)
        
        AVAudioSession.sharedInstance().setActive(true, withOptions: nil, error: nil)
        // new iOS 8 feature
        let mute = AVAudioSession.sharedInstance().secondaryAudioShouldBeSilencedHint
        let s = mute ? "to" : "not"
        println("I need \(s) mute my secondary audio at this point")
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        println("bp in \(__FUNCTION__)")
    }


    
    
    
    
    

}

