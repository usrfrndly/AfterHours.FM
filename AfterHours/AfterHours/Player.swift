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
    //var player : AVPlayer!
    var player:STKAudioPlayer!
    //var playerLayer : AVPlayerLayer? = nil
    //var asset : AVAsset? = nil
    //var playerItem: AVPlayerItem? = nil
   var forever = false
    weak var delegate : PlayerDelegate?
    var observer : NSObjectProtocol!
    var isPlaying:Bool = false
    let path = "http://relay.ah.fm/;"
    let fileURL:NSURL!
    var show: String = "Radio Show"
    var dj: String = "DJ Name"
    var banner: String = "http://dev.ah.fm/assets/default.jpg"

    
    init() {
        
        // interruption notification
        fileURL = NSURL(string:path)!
        self.setupStream()

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
                                    let ok: Void? = self?.player.playURL(self?.fileURL)
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
    
   func setupStream() {
    
        let equalizerB:(Float32, Float32, Float32, Float32, Float32, Float32, Float32, Float32, Float32, Float32, Float32, Float32, Float32, Float32, Float32, Float32, Float32, Float32, Float32, Float32, Float32, Float32, Float32, Float32) = (50, 100, 200, 400, 800, 600, 2600, 16000, 0, 0, 0, 0, 0, 0 , 0, 0, 0, 0, 0, 0, 0, 0 , 0, 0 )
    
        var optns:STKAudioPlayerOptions = STKAudioPlayerOptions(flushQueueOnSeek: true, enableVolumeMixer: true, equalizerBandFrequencies:equalizerB,readBufferSize: 0, bufferSizeInSeconds: 0, secondsRequiredToStartPlaying: 0, gracePeriodAfterSeekInSeconds: 0, secondsRequiredToStartPlayingAfterBufferUnderun: 0)
    
        println("bp making a new Player")
        self.player = STKAudioPlayer(options: optns)
    
        AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, withOptions: nil, error: nil)
        AVAudioSession.sharedInstance().setActive(true, withOptions: nil, error: nil)

        println("bp trying to play \(path)")
    }
    
    func stop () {
        println("Player.stop() called")
        self.player?.pause()
        self.isPlaying = false
    }
    
    func setTitleAndArtistAndImage(artist: String,title:String, url:String ){
        println("Player.setTitleAndArtist(artist: \(artist), title:\(title)), url:\(url)")
        let mpNowPlayingCenter = MPNowPlayingInfoCenter.defaultCenter()
        let urlPath = NSURL(string:url)
        var err: NSError?
        var imageData :NSData = NSData(contentsOfURL:urlPath!,options: NSDataReadingOptions.DataReadingMappedIfSafe, error: &err)!
        var img:UIImage = UIImage(data:imageData)!
        var artwork = MPMediaItemArtwork(image:img)
        mpNowPlayingCenter.nowPlayingInfo = [MPMediaItemPropertyArtist :artist, MPMediaItemPropertyTitle : title,MPMediaItemPropertyArtwork: artwork]
    }
    
    func audioPlayerDidFinishPlaying(AVPlayer!, successfully: Bool) {
    println("Player.audioPlayerDidFinishPlaying()")

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
        self.player?.delegate = nil
    }

}