//
//  AppDelegate.swift
//  AfterHours
//
//  Created by Aleksandr Rogozin on 11/25/14.
//  Copyright (c) 2014 Aleksandr Rogozin. All rights reserved.
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
    var player: Player = Player()
    
    func fired(timer:NSTimer) {
        println("bp timer fired")
    }
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        println("Called AppDelegate:application(application: UIApplication, didFinishLaunchingWithOptions)")
        
        var err: NSErrorPointer = nil
        AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, withOptions: nil, error:err)
        UIApplication.sharedApplication().beginReceivingRemoteControlEvents()
        self.becomeFirstResponder()

        return true
    }
    
    override func canBecomeFirstResponder() -> Bool {
        println("ViewController.canBecomeFirstResponder()")
        return true
    }
    
    override func remoteControlReceivedWithEvent(receivedEvent: UIEvent) {
        let eventType = receivedEvent.subtype
        switch eventType {
        case .RemoteControlTogglePlayPause:
            if self.player.isPlaying {
                self.player.stop()
            }
            else {
                self.player.play()
            }
            
        case .RemoteControlPlay:
            self.player.play()
            
        case .RemoteControlPause:
            self.player.stop()
            
        default:
            break
        }
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
        println("Called AppDelegate.\(__FUNCTION__)")
        //self.timer?.invalidate()
        //self.timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "fired:", userInfo: nil, repeats: true)
        
        return
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        println("AppDelegate.\(__FUNCTION__)")
        println("Player state: \(self.player.isPlaying)")
        //println("bp state while entering background: \(application.applicationState.rawValue)")
        /*
        delay(2) {
            println("AppDelegate.delay(), and attempting to fire local notification")
            let localNotification = UILocalNotification()
            localNotification.alertBody = "Testing"
            application.presentLocalNotificationNow(localNotification)
        }
        */
        println("\(self.player.player.progress)")
        return
    }
    
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        println("AppDelegate received local notification reading \(notification.alertBody)")
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        println("AppDelegate.\(__FUNCTION__)")
        println("Player state: \(self.player.isPlaying)")
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        println("AppDelegate.\(__FUNCTION__)")
        println("Player state: \(self.player.isPlaying)")
        let types : UIUserNotificationType = .Alert
        let settings = UIUserNotificationSettings(forTypes: types, categories: nil)
        application.registerUserNotificationSettings(settings)
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        println("AppDelegate.\(__FUNCTION__)")
    }


}

