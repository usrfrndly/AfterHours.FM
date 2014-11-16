//
//  Player.swift
//  Music
//
//  Created by Jaclyn May on 11/16/14.
//  Copyright (c) 2014 NYU. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer

@objc protocol PlayerDelegate {
    func soundFinished(sender : AnyObject)
}

class Player{
    var player : AVPlayer!
    var playerLayer : AVPlayerLayer? = nil
    var asset : AVAsset? = nil
    var playerItem: AVPlayerItem? = nil
    var forever = false
    weak var delegate : PlayerDelegate?
    var observer : NSObjectProtocol!
    var isPlaying:Bool = false
    
    init() {
        
        // interruption notification
        // note (irrelevant for bk 2, but useful for bk 1) how to prevent retain cycle
        
        self.observer = NSNotificationCenter.defaultCenter().addObserverForName(
            AVAudioSessionInterruptionNotification, object: nil, queue: NSOperationQueue.mainQueue(), usingBlock: {
                [weak self](n:NSNotification!) in
                let why : AnyObject? = n.userInfo?[AVAudioSessionInterruptionTypeKey]
                if let why = why as? UInt {
                    if let why = AVAudioSessionInterruptionType(rawValue: why) {
                        if why == .Began {
                            println("interruption began:\n\(n.userInfo!)")
                        } else {
                            println("interruption ended:\n\(n.userInfo!)")
                            let opt : AnyObject? = n.userInfo![AVAudioSessionInterruptionOptionKey]
                            if let opt = opt as? UInt {
                                let opts = AVAudioSessionInterruptionOptions(opt)
                                if opts == .OptionShouldResume {
                                    println("should resume")
                                    let ok: Void? = self?.player.play()
                                    self?.isPlaying = true
                                    
                                    println("bp tried to resume play: did I? \(ok)")
                                } else {
                                    println("not should resume")
                                }
                            }
                        }
                    }
                }
        })
    }
    
    func stop () {
        self.player?.pause()
        self.isPlaying = false
    }
    
    func playFileAtPath() {
        //self.player?.delegate = nil
        
        self.player?.pause()
        self.isPlaying = false
        let path = "http://relay.ah.fm/;"
        let fileURL:NSURL = NSURL(string:path)!
        println("bp making a new Player")
        self.asset = AVAsset.assetWithURL(fileURL) as? AVAsset
        self.playerItem = AVPlayerItem(asset: self.asset)
        self.player = AVPlayer(playerItem: self.playerItem)
        self.playerLayer = AVPlayerLayer(player: self.player)
        
        // error-checking omitted
        
        AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, withOptions: nil, error: nil)
        AVAudioSession.sharedInstance().setActive(true, withOptions: nil, error: nil)
        
        
        //self.player.prepareToPlay()
        //self.player.delegate = self
        //let ok: Void = self.player.play()
        //self.isPlaying = true
        println("bp trying to play \(path)")
    }
    
    func audioPlayerDidFinishPlaying(AVPlayer!, successfully: Bool) {
        let sess = AVAudioSession.sharedInstance()
        sess.setActive(false, withOptions: .OptionNotifyOthersOnDeactivation, error: nil)
        sess.setCategory(AVAudioSessionCategoryAmbient, withOptions: nil, error: nil)
        sess.setActive(true, withOptions: nil, error: nil)
        delegate?.soundFinished(self)
    }
    
    // to hear about interruptions, in iOS 8, use the session notifications
    
    
    
    deinit {
        println("bp player dealloc")
        if self.observer != nil {
            NSNotificationCenter.defaultCenter().removeObserver(self.observer)
        }
        //self.player?.delegate = nil
    }

}