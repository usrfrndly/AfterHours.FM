//
//  Player.swift
//  Player
//
//  Created by Aleksandr Rogozin on 11/25/14.
//  Copyright (c) 2014 Aleksandr Rogozin. All rights reserved.
//

import Foundation
import AVFoundation
import MediaPlayer

@objc protocol PlayerDelegate {
    func soundFinished(sender : AnyObject)
}

class Player {
    var player:STKAudioPlayer!
    weak var delegate : PlayerDelegate?
    var observer : NSObjectProtocol!
    var isPlaying:Bool = false
    let fileURL:NSURL! = NSURL(string:"http://relay.ah.fm/;")
    
    init() {
        self.addInterruptionNotification()
    }
    
    func addInterruptionNotification(){
        self.observer = NSNotificationCenter.defaultCenter().addObserverForName(
            AVAudioSessionInterruptionNotification, object: nil, queue: NSOperationQueue.mainQueue(), usingBlock: {
                [weak self](notification:NSNotification!) in
                let whyInterrupted : AnyObject? = notification.userInfo?[AVAudioSessionInterruptionTypeKey]
                if let whyInterrupted = whyInterrupted as? UInt {
                    if let whyInterrupted = AVAudioSessionInterruptionType(rawValue: whyInterrupted) {
                        if whyInterrupted == .Began {
                            println("interruption began:\n\(notification.userInfo!)")
                        } else {
                            println("interruption ended:\n\(notification.userInfo!)")
                            let option : AnyObject? = notification.userInfo![AVAudioSessionInterruptionOptionKey]
                            if let option = option as? UInt {
                                let options = AVAudioSessionInterruptionOptions(option)
                                if options == .OptionShouldResume {
                                    println("should resume")
                                    let resumed: Void? = self?.player.playURL(self?.fileURL)
                                    self?.isPlaying = true
                                    
                                    println("bp tried to resume play: did I? \(resumed)")
                                } else {
                                    println("not should resume")
                                }
                            }
                        }
                    }
                }
        })
    }
    
}