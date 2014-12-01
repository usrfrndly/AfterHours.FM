//
//  Player.swift
//  AfterHours
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

private let _PlayerASharedInstance = Player()

class Player {
    
    class var sharedInstance : Player {
        return _PlayerASharedInstance
    }
    
    var player:STKAudioPlayer!
    weak var delegate : PlayerDelegate?
    var observer : NSObjectProtocol!
    var isPlaying:Bool = false
    let streamURL:NSURL! = NSURL(string:"http://relay.ah.fm/;")
    
    init() {
        
        // Once player is initialized, set the background mode and make the player active
        /// This sets the frequencies of the equalizer bands of the graphic equalizer built into STKAudioPlayer
        let equalizerBands:(Float32, Float32, Float32, Float32, Float32, Float32, Float32, Float32, Float32, Float32, Float32, Float32, Float32, Float32, Float32, Float32, Float32, Float32, Float32, Float32, Float32, Float32, Float32, Float32) = (50, 100, 200, 400, 800, 1600, 2600, 16000, 0, 0, 0, 0, 0, 0 , 0, 0, 0, 0, 0, 0, 0, 0 , 0, 0 )
        /// The options that the STKAudioPlayer should be initialized with. The 0 options enable the default options.
        var optns:STKAudioPlayerOptions = STKAudioPlayerOptions(flushQueueOnSeek: true, enableVolumeMixer: true, equalizerBandFrequencies:equalizerBands,readBufferSize: 0, bufferSizeInSeconds: 0, secondsRequiredToStartPlaying: 0, gracePeriodAfterSeekInSeconds: 0, secondsRequiredToStartPlayingAfterBufferUnderun: 0)
        
        println("Player.setupStream()")
        self.player = STKAudioPlayer(options: optns)
        self.player.meteringEnabled = true
        // Once player is initialized, set the background mode and make the player active
        self.makePlayerActive()
    }
    
    /**
    Sets player to active in the background mode
    */
    func makePlayerActive() {
        println("Called Player.makePlayerActive()")
        AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, withOptions: nil, error: nil)
        AVAudioSession.sharedInstance().setActive(true, withOptions: nil, error: nil)
        self.play()
    }
    
    /**
    Initializes Now Playing information
    
    :param: artist Artist string
    :param: title  Title string
    :param: imageUrl Image Url string
    */
    func updatePlayerInfo(artist: String, title: String, imageUrl: String ){
        println("Player.setTitleAndArtist(artist: \(artist), title:\(title)), image url:\(imageUrl)")
        let mpNowPlayingCenter = MPNowPlayingInfoCenter.defaultCenter()
        let urlPath = NSURL(string:imageUrl)
        var err: NSError?
        var imageData :NSData = NSData(contentsOfURL:urlPath!,options: NSDataReadingOptions.DataReadingMappedIfSafe, error: &err)!
        var img:UIImage = UIImage(data:imageData)!
        var artwork = MPMediaItemArtwork(image:img)
        mpNowPlayingCenter.nowPlayingInfo = [MPMediaItemPropertyArtist :artist, MPMediaItemPropertyTitle : title,MPMediaItemPropertyArtwork: artwork]
    }
    
    /**
    Make player respond to system interruptions and continue playing in the background
    */
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
                                    let resumed: Void? = self?.player.playURL(self?.streamURL)
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
    
    func play() {
        if (!self.isPlaying) {
            println("Player.play() called")
            self.player?.playURL(self.streamURL)
            self.isPlaying = true
        }
        
        println("Player state: \(self.isPlaying)")
    }
    
    func stop() {
        if (self.isPlaying) {
            println("Player.stop() called")
            self.player?.pause()
            self.isPlaying = false
        }
        
        println("Player state: \(self.isPlaying)")
    }
    
    func audioPlayerDidFinishPlaying(AVPlayer!, successfully: Bool) {
        println("Player.audioPlayerDidFinishPlaying()")
        
        let session = AVAudioSession.sharedInstance()
        session.setActive(false, withOptions: .OptionNotifyOthersOnDeactivation, error: nil)
        session.setCategory(AVAudioSessionCategoryAmbient, withOptions: nil, error: nil)
        session.setActive(true, withOptions: nil, error: nil)
        delegate?.soundFinished(self)
    }
    
    deinit {
        println("Player.deinit")
        if self.observer != nil {
            NSNotificationCenter.defaultCenter().removeObserver(self.observer)
        }
        self.player?.delegate = nil
    }


}