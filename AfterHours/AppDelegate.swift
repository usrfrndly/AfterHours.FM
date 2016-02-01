//
//  AppDelegate.swift
//  AfterHours
//
//  Created by Aleksandr Rogozin on 11/25/14.
//  Copyright (c) 2014 Aleksandr Rogozin. All rights reserved.
//

import UIKit
import AVFoundation


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let player: Player! = Player.sharedInstance
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        print("\(Mirror(reflecting:self).description).\(__FUNCTION__)():")
        
        let err: NSErrorPointer = nil
        do {
  
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, withOptions: [])
        } catch let error as NSError {
            err.memory = error
        }
        UIApplication.sharedApplication().beginReceivingRemoteControlEvents()
        self.becomeFirstResponder()

        return true
    }
    
    override func canBecomeFirstResponder() -> Bool {
        print("\(Mirror(reflecting:self).description).\(__FUNCTION__):")
        return true
    }
    
    override func remoteControlReceivedWithEvent(receivedEvent: UIEvent?) {
        print("\(Mirror(reflecting:self).description).\(__FUNCTION__)(recievedEvent: \(receivedEvent!.description))")
        var vc = window?.rootViewController as! ViewController
        let eventType = receivedEvent!.subtype
        switch eventType {
        case .RemoteControlTogglePlayPause:
            if self.player.isPlaying() {
                self.player.pause()
                var newBackgroundImg = UIImage(named: "Play.png")
                vc.togglePlayButton.setBackgroundImage(newBackgroundImg, forState: .Normal )
            }
            else {
                self.player.play()
                var newBackgroundImg = UIImage(named: "Pause_button.png")
                vc.togglePlayButton.setBackgroundImage(newBackgroundImg, forState: .Normal)
            }
            
        case .RemoteControlPlay:
            self.player.play()
            var newBackgroundImg = UIImage(named: "Pause_button.png")
            vc.togglePlayButton.setBackgroundImage(newBackgroundImg, forState: .Normal)
            
        case .RemoteControlPause:
            self.player.pause()
            var newBackgroundImg = UIImage(named: "Play.png")
            vc.togglePlayButton.setBackgroundImage(newBackgroundImg, forState: .Normal )
            
        default:
            break
        }
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
        print("\(Mirror(reflecting:self).description).\(__FUNCTION__)():")
        
        return
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        print("\(Mirror(reflecting:self).description).\(__FUNCTION__)():")
        print("player is playing: \(self.player.isPlaying)")
        //println("bp state while entering background: \(application.applicationState.rawValue)")
        return
    }
    
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        print("\(Mirror(reflecting:self).description).\(__FUNCTION__)():")

        print("AppDelegate received local notification reading \(notification.alertBody)")
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        print("\(Mirror(reflecting:self).description).\(__FUNCTION__)():")
        print("player is playing: \(self.player.isPlaying)")
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        print("\(Mirror(reflecting:self).description).\(__FUNCTION__)():")
        print("player is playing: \(self.player.isPlaying)")
        let types : UIUserNotificationType = .Alert
        let settings = UIUserNotificationSettings(forTypes: types, categories: nil)
        application.registerUserNotificationSettings(settings)
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        print("\(Mirror(reflecting:self).description).\(__FUNCTION__)():")
        //Turn off remote control event delivery
        UIApplication.sharedApplication().endReceivingRemoteControlEvents()
        //resign as first responder to events
        self.resignFirstResponder()
    }


}

