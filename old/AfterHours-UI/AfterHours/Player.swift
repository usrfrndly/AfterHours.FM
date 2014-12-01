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

/**
*  The Player class represents the properties of the streaming player, built from STKAudioPlayer
*/
class Player{
    /// The player
    var player:STKAudioPlayer!
    //TODO: What's this?
    var forever = false
    /// Delegate for the Player object
    weak var delegate : PlayerDelegate?
    /// Observer of Player object
    var observer : NSObjectProtocol!
    /// Is the player playing?
    var isPlaying:Bool = false
    /// AfterHours.fm URL stream
    let fileURL:NSURL! = NSURL(string:"http://relay.ah.fm/;")
    
    
    init() {
        self.setupStream()
        self.addInterruptionNotification()

    }
    
    /**
    Initializes the player from STKAudioPlayer class with the appropriate properties
    */
   func setupStream() {
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
    func makePlayerActive(){
        println("Called Player.makePlayerActive()")
        AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, withOptions: nil, error: nil)
        AVAudioSession.sharedInstance().setActive(true, withOptions: nil, error: nil)
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
    
    /**
    Pause player from playing
    */
    func stop () {
        println("Player.stop() called")
        self.player?.pause()
        self.isPlaying = false
    }
    
    /**
    Initializes Now Playing information
    
    :param: artist Artist string
    :param: title  Title string
    :param: imageUrl Image Url string
    */
    func setTitleAndArtistAndImage(artist: String,title:String, imageUrl:String ){
        println("Player.setTitleAndArtist(artist: \(artist), title:\(title)), url:\(imageUrl)")
        let mpNowPlayingCenter = MPNowPlayingInfoCenter.defaultCenter()
        let urlPath = NSURL(string:imageUrl)
        var err: NSError?
        var imageData :NSData = NSData(contentsOfURL:urlPath!,options: NSDataReadingOptions.DataReadingMappedIfSafe, error: &err)!
        var img:UIImage = UIImage(data:imageData)!
        var artwork = MPMediaItemArtwork(image:img)
        mpNowPlayingCenter.nowPlayingInfo = [MPMediaItemPropertyArtist :artist, MPMediaItemPropertyTitle : title,MPMediaItemPropertyArtwork: artwork]
    }
    
    //TODO: Not sure what this does...
    func audioPlayerDidFinishPlaying(AVPlayer!, successfully: Bool) {
        println("Player.audioPlayerDidFinishPlaying()")
        let sess = AVAudioSession.sharedInstance()
        sess.setActive(false, withOptions: .OptionNotifyOthersOnDeactivation, error: nil)
        sess.setCategory(AVAudioSessionCategoryAmbient, withOptions: nil, error: nil)
        sess.setActive(true, withOptions: nil, error: nil)
        delegate?.soundFinished(self)
    }
    
    //TODO: Not sure what this does...
    deinit {
        println("Player.deinit")
        if self.observer != nil {
            NSNotificationCenter.defaultCenter().removeObserver(self.observer)
        }
        self.player?.delegate = nil
    }

}