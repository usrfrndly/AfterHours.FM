import UIKit
import AVFoundation
import MediaPlayer

class EQController:UIViewController{
    var player:Player!
    var engine:AVAudioEngine!
    var playerNode:AVAudioPlayerNode!
    var mixer:AVAudioMixerNode!
    var sampler:AVAudioUnitSampler!
    var buffer:AVAudioPCMBuffer!
    var audioFile:AVAudioFile!
    var EQNode:AVAudioUnitEQ!
    
    /* EQ FILTER NODES */
    var reverbNode:AVAudioUnitReverb!
    var distortionNode:AVAudioUnitDistortion!
    var delayNode:AVAudioUnitDelay!
    var auVarispeed:AVAudioUnitVarispeed!
    var auTimePitch:AVAudioUnitTimePitch!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if player.isPlaying{
            initAudioEngine()
        }
        
        
    }
    /* EQ FILTERS */
    
    @IBAction func reverbWetDryMix(sender: UISlider) {
        reverbNode.wetDryMix = sender.value
    }
    
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
    func varispeed() {
        auVarispeed = AVAudioUnitVarispeed()
        auVarispeed.rate = 3 //The default value is 1.0. The range of values is 0.25 to 4.0.
        engine.attachNode(auVarispeed)
        engine.connect(playerNode, to: auVarispeed, format: mixer.outputFormatForBus(0))
        engine.connect(auVarispeed, to: mixer, format: mixer.outputFormatForBus(0))
    }
    
    func timePitch() {
        auTimePitch = AVAudioUnitTimePitch()
        auTimePitch.pitch = 1200 // In cents. The default value is 1.0. The range of values is -2400 to 2400
        auTimePitch.rate = 2 //The default value is 1.0. The range of supported values is 1/32 to 32.0.
        engine.attachNode(auTimePitch)
        engine.connect(playerNode, to: auTimePitch, format: mixer.outputFormatForBus(0))
        engine.connect(auTimePitch, to: mixer, format: mixer.outputFormatForBus(0))
    }
    /* EQ Controls */
    func initAudioEngine () {
        self.engine = AVAudioEngine()
        self.playerNode = AVAudioPlayerNode()
        //playerTapNode = AVAudioPlayerNode()
        self.engine.attachNode(self.playerNode)
        //engine.attachNode(playerTapNode)
        self.mixer = self.engine.mainMixerNode
        self.engine.connect(self.playerNode, to: self.mixer, format: self.mixer.outputFormatForBus(0))
        //        engine.connect(playerNode, to: engine.mainMixerNode, format: mixer.outputFormatForBus(0))
        var error:NSError?
        if !engine.startAndReturnError(&error){
            println("error couldnt start engine")
            if let e = error{
                println("error \(e.localizedDescription)")
            }
        }
        var er: NSError?
        self.audioFile = AVAudioFile(forReading:self.player.fileURL!, error:nil)
        if let err = er {
            println(err.localizedDescription)
        }
        
        self.engine.connect(self.playerNode, to:self.mixer,format: self.audioFile.processingFormat)
        self.playerNode.scheduleFile(self.audioFile, atTime:nil, completionHandler:nil)
        if self.engine.running {
            self.playerNode.play()
        } else {
            if !self.engine.startAndReturnError(&error) {
                println("error couldn't start engine")
                if let e = error {
                    println("error \(e.localizedDescription)")
                }
            } else {
                playerNode.play()
            }
        }
        
        mixer.outputVolume = 1.0
        mixer.pan = 0.0 // -1 to +1
        var iformat = engine.inputNode.inputFormatForBus(0)
        println("input format \(iformat)")
        
        
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
}
