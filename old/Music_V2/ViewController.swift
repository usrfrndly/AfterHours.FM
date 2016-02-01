//
//  ViewController.swift
//  AHFM
//

import UIKit
import AVFoundation
import MediaPlayer

class ViewController: UIViewController {
    /// Play button
    @IBOutlet weak var playerControlButton: UIButton!
    /// View Container that contains whatever is beneath the radio, such as the EQ
    @IBOutlet weak var containerView: UIView!
    /// EQ button to show EQ. Only shown when player is playing.
    @IBOutlet weak var EQButton: UIButton!
    
    /// Instance of the Player class
    var player:Player! = Player()
    
    // Instance of container view controller
    var containerViewController:ContainerViewController!
    
    
    /**
    Enables running the app in the background
    */
    override func canBecomeFirstResponder() -> Bool {
        print("ViewController.canBecomeFirstResponder()")
        return true
    }
    
    
    override func viewWillDisappear(animated: Bool) {
        print("ViewController.viewWillDisappear()")
        super.viewWillDisappear(animated)
        //Turn off remote control event delivery
        UIApplication.sharedApplication().endReceivingRemoteControlEvents()
        //resign as first responder to events
        self.resignFirstResponder()
    }
    
    /* Enables the app to be controlled from the notification center */
    override func viewDidLoad() {
        print("ViewController.viewDidLoad()")
        super.viewDidLoad()
        self.becomeFirstResponder()
        UIApplication.sharedApplication().beginReceivingRemoteControlEvents()
    }
    
    /**
    Responds to events to control player
    
    - parameter receivedEvent: The type of event used to control the player
    */
    override func remoteControlReceivedWithEvent(receivedEvent: UIEvent?) {
    print("ViewController.remoteControlReceivedWithEvent(event)")
        let eventType = receivedEvent!.subtype
        print("View Controller received remote control  type \(eventType.rawValue)")
            // 101 = pause, 100 = play (remote control interface on control center)
            // 103 = playpause (remote control button on earbuds)
        if let p = self.player{
            switch eventType{
            case .RemoteControlTogglePlayPause:
                if p.isPlaying {
                    self.pauseActions()
                } else {
                    self.playActions()
                }
            case .RemoteControlPlay:
                    self.playActions()

            case .RemoteControlPause:
                    self.pauseActions()
            
            default:
                break
            }
        }
    }
    
    
    
    /* Play or Pause stream */
    @IBAction func playControl(sender: AnyObject?){
        // If player is not playing, play. Else pause.
        if !self.player!.isPlaying {
            self.playActions()
        }
        else {
            self.pauseActions()
        }
    }
    
    /**
    Determines whether the View Controller should segue
    
    - parameter identifier: The segue identifier
    - parameter sender:     What called the segue
    
    - returns: Whether the View controller should segue
    */
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject!) -> Bool {
//        if identifier == "RadioToEQSegue" {
//        // by default, transition
//            return true
//        }
//        else if identifier == "ShowEQSegue"{
//            self.containerView.hidden = false
//            return true
//        }
//        else{
//            return false
//        }
        NSLog("\(__FILE__).\( __FUNCTION__)")
        return true
        
        
        
    }
    
    /**
    Prepares for segue to show EQ  view and passes the player instance to this
    new view
    
    - parameter segue:  The segue to te EQ
    - parameter sender: sender
    */
    override func prepareForSegue(segue: (UIStoryboardSegue!), sender: AnyObject!) {
        NSLog("\(__FILE__).\( __FUNCTION__)")
        if (segue.identifier == "embedContainer"){
            self.containerViewController = segue.destinationViewController as! ContainerViewController
            containerViewController.player = self.player
            //var svc = segue!.destinationViewController as EQViewController;
            //svc.player = self.player
        }
    }
    
    /* The set of changes made every time player is made to play */
    func playActions(){
        if let p = self.player{
            self.player.isPlaying = true
            if let po = self.player.player{
                self.player.player.playURL(player.fileURL)
            }
        }
        
        //TODO: artist, title and imageUrl should be dynamically populated
        self.player.setTitleAndArtistAndImage("artist", title: "title", imageUrl: "http://www.ah.fm/files/djs/goodgreef.jpg")
    self.playerControlButton.setTitle("Stop", forState: UIControlState.Normal)
        self.EQButton.hidden = false
    }
    
    /* The set of changes made every time   
    player is paused */
    func pauseActions(){
        if let p = self.player{
            self.player.isPlaying=false
            if let po = self.player.player{
                self.player.player.pause()
            }
        }
        self.playerControlButton.setTitle("Play", forState: UIControlState.Normal)
        self.EQButton.hidden = true
    }
    
    
    @IBAction func showEQ(sender: AnyObject) {
        self.containerViewController.swapViewControllers()
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
        
    
}
