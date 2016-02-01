import UIKit
import AVFoundation
import MediaPlayer

class EQViewController:UIViewController{
    var player:Player = Player.sharedInstance
    var engine:AVAudioEngine!
    var playerNode:AVAudioPlayerNode!
    var mixer:AVAudioMixerNode!
    var sampler:AVAudioUnitSampler!
    var buffer:AVAudioPCMBuffer!
    var audioFile:AVAudioFile!
    var EQNode:AVAudioUnitEQ!
    
     @IBOutlet var navBarItem: UINavigationItem!
    @IBOutlet weak var radioshowLabel: UILabel!
    @IBOutlet weak var djLabel: UILabel!
    @IBAction func playlistPressed(sender: AnyObject) {
    }
    @IBOutlet weak var togglePlayButton: UIButton!

    
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
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        NSLog("\(__FILE__).\( __FUNCTION__)")
        super.viewDidLoad()
        if(player.isPlaying()){
            let newBackgroundImg = UIImage(named: "Pause.png")
            self.togglePlayButton.setBackgroundImage(newBackgroundImg, forState: .Normal)
        }else{
            let newBackgroundImg = UIImage(named: "Play.png")
            self.togglePlayButton.setBackgroundImage(newBackgroundImg, forState: .Normal )
        }

        //println("Equalizer Enabled: \(player.player.equalizerEnabled)")
        let firebase = Firebase(url: "https://ahfm.firebaseio.com/playlist")
        firebase.observeEventType(.Value, withBlock: {
            snapshot in
            self.radioshowLabel.text = snapshot.value.objectForKey("title") as? String
            self.djLabel.text = snapshot.value.objectForKey("dj") as? String
        })
        
        let img:UIImage? = UIImage(named: "menu.png")
        navBarItem.leftBarButtonItem = UIBarButtonItem(image: img!, style: UIBarButtonItemStyle.Bordered , target:self, action: "toggleSideMenuView")
        
    }
    @IBAction func togglePlayButtonPressed(sender: UIButton?){
        //let playerStateValue = self.player.getPlayerState()
        //println("Player state value: \(self.player.player.state.value)")
        if self.player.isPlaying(){
            print("\(Mirror(reflecting:self).description).\(__FUNCTION__)(): Pause stream")
            self.player.pause()
            let newBackgroundImg = UIImage(named: "Play.png")
            self.togglePlayButton.setBackgroundImage(newBackgroundImg, forState: .Normal )
        }else{
            print("\(Mirror(reflecting:self).description).\(__FUNCTION__)(): Play Strean")
            self.player.play()
            let newBackgroundImg = UIImage(named: "Pause.png")
            self.togglePlayButton.setBackgroundImage(newBackgroundImg, forState: .Normal)
        }
    }
    
    func toggleSideMenu(sender: AnyObject) {
        toggleSideMenuView()
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
