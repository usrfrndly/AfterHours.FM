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
    //var isPlaying:Bool = false

    let streamURL:NSURL! = NSURL(string:"http://relay.ah.fm/;")
    
    /*
    Each STKAudioPlayerState corresponds to a certain value as follows:
    STKAudioPlayerStateReady.value: 0
    STKAudioPlayerStateRunning.value: 1
    STKAudioPlayerStatePlaying.value: 3
    STKAudioPlayerStateBuffering.value: 5
    STKAudioPlayerStatePaused.value: 9
    STKAudioPlayerStateStopped.value: 16
    STKAudioPlayerStateError.value: 32
    */
    let playerStates:[UInt32:String!] = [ STKAudioPlayerStateReady.rawValue:"STKAudioPlayerStateReady", STKAudioPlayerStateRunning.rawValue:"STKAudioPlayerStateRunning", STKAudioPlayerStatePlaying.rawValue:"STKAudioPlayerStatePlaying", STKAudioPlayerStateBuffering.rawValue:"STKAudioPlayerStateBuffering",STKAudioPlayerStatePaused.rawValue:"STKAudioPlayerStatePaused", STKAudioPlayerStateStopped.rawValue:"STKAudioPlayerStateStopped", STKAudioPlayerStateError.rawValue:"STKAudioPlayerStateError" ]
    
    init() {
        self.setupStream()
        self.addInterruptionNotification()
        
        let firebase = Firebase(url: "https://ahfm.firebaseio.com/playlist")
        firebase.observeEventType(.Value, withBlock: {
            snapshot in
            self.updatePlayerInfo(snapshot.value.objectForKey("dj") as! String, title: snapshot.value.objectForKey("title") as! String, imageUrl: snapshot.value.objectForKey("banner") as! String)
        })
    }
    
    func setupStream() {
        /// This sets the frequencies of the equalizer bands of the graphic equalizer built into STKAudioPlayer
        let equalizerBands:(Float32, Float32, Float32, Float32, Float32, Float32, Float32, Float32, Float32, Float32, Float32, Float32, Float32, Float32, Float32, Float32, Float32, Float32, Float32, Float32, Float32, Float32, Float32, Float32) = (50, 100, 200, 400, 800, 1600, 2600, 16000, 0, 0, 0, 0, 0, 0 , 0, 0, 0, 0, 0, 0, 0, 0 , 0, 0 )
        /// The options that the STKAudioPlayer should be initialized with. The 0 options enable the default options.
        let optns:STKAudioPlayerOptions = STKAudioPlayerOptions(flushQueueOnSeek: true, enableVolumeMixer: true, equalizerBandFrequencies:equalizerBands,readBufferSize: 0, bufferSizeInSeconds: 0, secondsRequiredToStartPlaying: 0, gracePeriodAfterSeekInSeconds: 0, secondsRequiredToStartPlayingAfterBufferUnderun: 0)
        
        print("Player.setupStream()")
        self.player = STKAudioPlayer(options: optns)
        self.player.meteringEnabled = true
        // Once player is initialized, set the background mode and make the player active
        self.makePlayerActive()
    }
    
    /**
    Sets player to active in the background mode
    */
    func makePlayerActive() {
        print("\(Mirror(reflecting:self).description).\(__FUNCTION__):")
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, withOptions: [])
        } catch _ {
        }
        do {
            try AVAudioSession.sharedInstance().setActive(true, withOptions: [])
        } catch _ {
        }

    
    }
    
    /**
    Initializes Now Playing information
    
    - parameter artist: Artist string
    - parameter title:  Title string
    - parameter imageUrl: Image Url string
    */
    func updatePlayerInfo(artist: String, title: String, imageUrl: String ){
        print("\(Mirror(reflecting:self).description).\(__FUNCTION__)(): \(artist), title:\(title)), image url:\(imageUrl)")
        let mpNowPlayingCenter = MPNowPlayingInfoCenter.defaultCenter()
        let urlPath = NSURL(string:imageUrl)
        var err: NSError?
        let imageData :NSData = try! NSData(contentsOfURL:urlPath!,options: NSDataReadingOptions.DataReadingMappedIfSafe)
        let img:UIImage = UIImage(data:imageData)!
        let artwork = MPMediaItemArtwork(image:img)
        mpNowPlayingCenter.nowPlayingInfo = [MPMediaItemPropertyArtist :artist, MPMediaItemPropertyTitle : title,MPMediaItemPropertyArtwork: artwork]
    }
    
    /**
    Make player respond to system interruptions and continue playing in the background
    */
    func addInterruptionNotification(){
        print("\(Mirror(reflecting:self).description).\(__FUNCTION__)():")
        self.observer = NSNotificationCenter.defaultCenter().addObserverForName(
            AVAudioSessionInterruptionNotification, object: nil, queue: NSOperationQueue.mainQueue(), usingBlock: {
                [weak self](notification:NSNotification!) in
                let whyInterrupted : AnyObject? = notification.userInfo?[AVAudioSessionInterruptionTypeKey]
                if let whyInterrupted = whyInterrupted as? UInt {
                    if let whyInterrupted = AVAudioSessionInterruptionType(rawValue: whyInterrupted) {
                        if whyInterrupted == .Began {
                            print("\(Mirror(reflecting:self).description).\(__FUNCTION__)():interruption began:\n\(notification.userInfo!)")
                        } else {
                            print("\(Mirror(reflecting:self).description).\(__FUNCTION__)():interruption ended:\n\(notification.userInfo!)")
                            let option : AnyObject? = notification.userInfo![AVAudioSessionInterruptionOptionKey]
                            if let option = option as? UInt {
                                let options = AVAudioSessionInterruptionOptions(rawValue: option)
                                if options == .ShouldResume {
                                    print("should resume")
                                    let resumed: Void? = self?.player.playURL(self?.streamURL)
                                              
                                    print("bp tried to resume play: did I? \(resumed)")
                                } else {
                                    print("not should resume")
                                }
                            }
                        }
                    }
                }
        })
    }
    
    
    func getPlayerState() -> UInt32{
        let playerStateValue = self.player.state.rawValue
        print("\(Mirror(reflecting:self).description).\(__FUNCTION__): Player state value: \(playerStateValue). Player state: \(playerStates[playerStateValue]!)")
        return playerStateValue
    }
//    
//    func isPlaying() -> Bool{
//        print("\(Mirror(reflecting:self).description).\(__FUNCTION__): ")
//        switch self.getPlayerState(){
//        case STKAudioPlayerStatePlaying.rawValue, STKAudioPlayerStateBuffering.rawValue:
//            return true
//        default:
//            return false
//        }
//    }
    
    func play() {
        print("\(Mirror(reflecting:self).description).\(__FUNCTION__):")
        if self.getPlayerState() == STKAudioPlayerStateReady.rawValue{
            self.player?.playURL(self.streamURL)
        }else{
            self.player.resume()
        }
        

    }
    func isPlaying() -> Bool{
        print("\(Mirror(reflecting:self).description).\(__FUNCTION__): ")
        switch self.getPlayerState(){
        case STKAudioPlayerStatePlaying.rawValue, STKAudioPlayerStateBuffering.rawValue:
            return true
        default:
            return false
        }
    }
    
    func pause() {
        print("\(Mirror(reflecting:self).description).\(__FUNCTION__):")
        self.player?.pause()
        self.getPlayerState()
    }
    
    func audioPlayerDidFinishPlaying(_: AVPlayer!, successfully: Bool) {
        print("\(Mirror(reflecting:self).description).\(__FUNCTION__)():")
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setActive(false, withOptions: .NotifyOthersOnDeactivation)
        } catch _ {
        }
        do {
            try session.setCategory(AVAudioSessionCategoryAmbient, withOptions: [])
        } catch _ {
        }
        do {
            try session.setActive(true, withOptions: [])
        } catch _ {
        }
        delegate?.soundFinished(self)
    }
    /**
     Pause player from playing
     */
    func stop () {
        print("Player.stop() called")
        self.player?.pause()
    }
    
    deinit {
        print("Player.deinit")
        if self.observer != nil {
            NSNotificationCenter.defaultCenter().removeObserver(self.observer)
        }
        self.player?.delegate = nil
    }


}