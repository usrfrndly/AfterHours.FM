import UIKit
import AVFoundation
import MediaPlayer

class EQViewController:UIViewController{
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
    
    override init(nibName: String?, bundle: NSBundle?) {
            super.init(nibName: nibName,bundle: bundle)
            //Custom Initialization when we need it
            
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        NSLog("\(__FILE__).\( __FUNCTION__)")
        super.viewDidLoad()
        //println("Equalizer Enabled: \(player.player.equalizerEnabled)")
        
    }
    
    /* New EQ Filters */
    

    
    @IBAction func EQ50HertzChanged(sender: UISlider){
        player.player.setGain(sender.value, forEqualizerBand: 0)
    }

    @IBAction func EQ100HertzChanged(sender: UISlider){
        player.player.setGain(sender.value, forEqualizerBand: 1)
    }
    
    @IBAction func EQ200HertzChanged(sender: UISlider) {
        player.player.setGain(sender.value, forEqualizerBand: 2)
    }
    
    @IBAction func EQ400HertzChanged(sender: UISlider) {
        player.player.setGain(sender.value, forEqualizerBand: 3)
    }
    
    @IBAction func EQ800HertzChanged(sender: UISlider) {
        player.player.setGain(sender.value, forEqualizerBand: 4)
    }

    @IBAction func EQ1600HertzChanged(sender: UISlider) {
        player.player.setGain(sender.value, forEqualizerBand: 5)
    }
    
    @IBAction func EQ2600HertzChanged(sender: UISlider) {
        player.player.setGain(sender.value, forEqualizerBand: 6)
    }

    @IBAction func EQ16000HertzChanged(sender: UISlider) {
        player.player.setGain(sender.value, forEqualizerBand: 7)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

}
