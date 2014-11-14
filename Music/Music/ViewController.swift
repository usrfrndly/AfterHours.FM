//
//  ViewController.swift
//  AHFM
//

import UIKit
import AVFoundation
import MediaPlayer

class ViewController: UIViewController {
    @IBOutlet weak var playerControlButton: UIButton!
    var player : AVPlayer? = nil
    var playerLayer : AVPlayerLayer? = nil
    var asset : AVAsset? = nil
    var playerItem: AVPlayerItem? = nil
    var engine:AVAudioEngine!
    var playerNode:AVAudioPlayerNode!
    var playerTapNode:AVAudioPlayerNode!
    var mixer:AVAudioMixerNode!
    var sampler:AVAudioUnitSampler!
    var buffer:AVAudioPCMBuffer!
    var audioFile:AVAudioFile!
    var mpNowPlayingCenter:MPNowPlayingInfoCenter!
    
    var isPlaying = false
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    override  func viewWillDisappear(animated: Bool) {
        //Turn off remote control event delivery
        UIApplication.sharedApplication().endReceivingRemoteControlEvents()
        //resign as first responder to events
        self.resignFirstResponder()
        super.viewWillDisappear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Turn on remote control event delivery
        UIApplication.sharedApplication().beginReceivingRemoteControlEvents()
        // Set itself as first responder
        self.becomeFirstResponder()
        
        
        // Do any additional setup after loading the view, typically from a nib.
        
        /*
        var object = PFObject(className: "Messages")
        /*
        object.addObject("Hello World!", forKey: "message")
        object.saveEventually()
        */
        
        var query = PFQuery(className: "Message")
        println(query.findObjects())
        */
        
        /* Initialize radio streaming */
        
        let audioURLWithPath = "http://relay.ah.fm/;"
        let audioURL = NSURL(string: audioURLWithPath)
        asset = AVAsset.assetWithURL(audioURL) as? AVAsset
        playerItem = AVPlayerItem(asset: asset)
        player = AVPlayer(playerItem: self.playerItem)
        playerLayer = AVPlayerLayer(player: self.player)
        mpNowPlayingCenter = MPNowPlayingInfoCenter.defaultCenter()
        // Sets Now Playing information for iPhone slide up menu
        mpNowPlayingCenter.nowPlayingInfo = [MPMediaItemPropertyArtist : "Artist!",  MPMediaItemPropertyTitle : "Title!"]
        //mpNowPlayingCenter.
        
    }
    
    override func remoteControlReceivedWithEvent(receivedEvent: UIEvent) {
        if receivedEvent.type == UIEventType.RemoteControl{
            switch receivedEvent.subtype{
            case UIEventSubtype.RemoteControlTogglePlayPause:
                self.playControl(nil)
                break
            default:
                break
            }
        }
    }
    
    /* Play or Pause stream */
    @IBAction func playControl(sender: AnyObject?) {
        if (!isPlaying) {
            player!.play()
            isPlaying = true
            playerControlButton.setTitle("Stop", forState: UIControlState.Normal)
        }
        else {
            player!.pause()
            isPlaying = false
            playerControlButton.setTitle("Play", forState: UIControlState.Normal)
        }
    }
    
    /* EQ Controls */
    func initAudioEngine () {
        
        engine = AVAudioEngine()
        playerNode = AVAudioPlayerNode()
        playerTapNode = AVAudioPlayerNode()
        engine.attachNode(playerNode)
        engine.attachNode(playerTapNode)
        mixer = engine.mainMixerNode
        // engine.connect(playerNode, to: mixer, format: mixer.outputFormatForBus(0))
        //        engine.connect(playerNode, to: engine.mainMixerNode, format: mixer.outputFormatForBus(0))
        
        mixer.outputVolume = 1.0
        mixer.pan = 0.0 // -1 to +1
        var iformat = engine.inputNode.inputFormatForBus(0)
        println("input format \(iformat)")
        
        var error: NSError?
        if !engine.startAndReturnError(&error) {
            println("error couldn't start engine")
            if let e = error {
                println("error \(e.localizedDescription)")
            }
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector:"configChange:",
            name:AVAudioEngineConfigurationChangeNotification,
            object:engine)
        
        reverb()
        distortion()
        delay()
        //        addEQ(audioFile)
        //        timePitch()
        //        varispeed()
        
        var format = mixer.outputFormatForBus(0)
        //engine.connect(playerNode, to: mixer, format: format)
        
        engine.connect(playerNode, to: reverbNode, format: format)
        engine.connect(reverbNode, to: distortionNode, format: format)
        engine.connect(distortionNode, to: delayNode, format: format)
        engine.connect(delayNode, to: mixer, format: format)
        
        // tapMixer()
        
        
    }
    
    
    
    @IBAction func reverbWetDryMix(sender: UISlider) {
        reverbNode.wetDryMix = sender.value
    }
    
    var reverbNode:AVAudioUnitReverb!
    func reverb() {
        reverbNode = AVAudioUnitReverb()
        reverbNode.loadFactoryPreset(.Cathedral)
        engine.attachNode(reverbNode)
        //The blend is specified as a percentage. The range is 0% (all dry) through 100% (all wet).
        reverbNode.wetDryMix = 0.0
        // engine.connect(playerNode, to: reverbNode, format: mixer.outputFormatForBus(0))
        // engine.connect(reverbNode, to: mixer, format: mixer.outputFormatForBus(0))
    }
    
    @IBAction func distortionWetDryMix(sender: UISlider) {
        distortionNode.wetDryMix = sender.value
    }
    
    var distortionNode:AVAudioUnitDistortion!
    func distortion() {
        distortionNode = AVAudioUnitDistortion()
        distortionNode.loadFactoryPreset(.SpeechAlienChatter)
        // The blend is specified as a percentage. The default value is 50%. The range is 0% (all dry) through 100% (all wet).
        distortionNode.wetDryMix = 0
        //The default value is -6 db. The valid range of values is -80 db to 20 db
        distortionNode.preGain = 0
        engine.attachNode(distortionNode)
        //engine.connect(playerNode, to: auDistortion, format: mixer.outputFormatForBus(0))
        //engine.connect(auDistortion, to: mixer, format: mixer.outputFormatForBus(0))
    }
    
    @IBAction func delayWetDryMix(sender: UISlider) {
        delayNode.wetDryMix = sender.value
    }
    
    @IBAction func delayTime(sender: UISlider) {
        var t = NSTimeInterval(sender.value)
        delayNode.delayTime = t
    }
    
    @IBAction func delayFeedback(sender: UISlider) {
        delayNode.feedback = sender.value
    }
    
    @IBAction func delayLowpass(sender: UISlider) {
        delayNode.lowPassCutoff = sender.value
    }
    
    var delayNode:AVAudioUnitDelay!
    func delay() {
        delayNode = AVAudioUnitDelay()
        //The delay is specified in seconds. The default value is 1. The valid range of values is 0 to 2 seconds.
        delayNode.delayTime = 1
        
        //The feedback is specified as a percentage. The default value is 50%. The valid range of values is -100% to 100%.
        delayNode.feedback = 50
        
        // The default value is 15000 Hz. The valid range of values is 10 Hz through (sampleRate/2).
        delayNode.lowPassCutoff = 5000
        
        
        //The blend is specified as a percentage. The default value is 100%. The valid range of values is 0% (all dry) through 100% (all wet).
        delayNode.wetDryMix = 0
        
        engine.attachNode(delayNode)
        // engine.connect(playerNode, to: auDelay, format: mixer.outputFormatForBus(0))
        // engine.connect(auDelay, to: mixer, format: mixer.outputFormatForBus(0))
    }
    
    var EQNode:AVAudioUnitEQ!
    func addEQ() {
        EQNode = AVAudioUnitEQ(numberOfBands: 2)
        engine.attachNode(EQNode)
        
        var filterParams = EQNode.bands[0] as AVAudioUnitEQFilterParameters
        filterParams.filterType = .HighPass
        filterParams.frequency = 80.0
        
        filterParams = EQNode.bands[1] as AVAudioUnitEQFilterParameters
        filterParams.filterType = .Parametric
        filterParams.frequency = 500.0
        filterParams.bandwidth = 2.0
        filterParams.gain = 4.0
        
        var format = mixer.outputFormatForBus(0)
        engine.connect(playerNode, to: EQNode, format: format )
        engine.connect(EQNode, to: engine.mainMixerNode, format: format)
    }
    
    var auVarispeed:AVAudioUnitVarispeed!
    func varispeed() {
        auVarispeed = AVAudioUnitVarispeed()
        auVarispeed.rate = 3 //The default value is 1.0. The range of values is 0.25 to 4.0.
        engine.attachNode(auVarispeed)
        engine.connect(playerNode, to: auVarispeed, format: mixer.outputFormatForBus(0))
        engine.connect(auVarispeed, to: mixer, format: mixer.outputFormatForBus(0))
    }
    
    var auTimePitch:AVAudioUnitTimePitch!
    func timePitch() {
        auTimePitch = AVAudioUnitTimePitch()
        auTimePitch.pitch = 1200 // In cents. The default value is 1.0. The range of values is -2400 to 2400
        auTimePitch.rate = 2 //The default value is 1.0. The range of supported values is 1/32 to 32.0.
        engine.attachNode(auTimePitch)
        engine.connect(playerNode, to: auTimePitch, format: mixer.outputFormatForBus(0))
        engine.connect(auTimePitch, to: mixer, format: mixer.outputFormatForBus(0))
    }
    
    @IBAction func playerNodeAction(sender: AnyObject) {
        playerNode.scheduleFile(audioFile, atTime:nil, completionHandler:nil)
        playerNodePlay()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func radiansToDegrees(radians:Double) -> Double {
        return radians * (180.0 / M_PI)
    }
    
    func degreesToRadians(degrees:Double) -> Double {
        return degrees / (180.0 * M_PI)
    }
    
    /**
    Uses an AVAudioPlayerNode to play an audio file.
    */
    func playerNodePlay() {
        if engine.running {
            println("engine is running")
            engine.disconnectNodeOutput(engine.inputNode)
            engine.connect(playerNode, to: reverbNode, format: mixer.outputFormatForBus(0))
            playerNode.play()
        } else {
            var error: NSError?
            if !engine.startAndReturnError(&error) {
                println("error couldn't start engine")
                if let e = error {
                    println("error \(e.localizedDescription)")
                }
            } else {
                playerNode.play()
            }
        }
    }
    
    
}
