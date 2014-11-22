//
//  ViewController.swift
//  AHFM
//

import UIKit
import AVFoundation
import MediaPlayer
class ViewController: UIViewController {
    @IBOutlet weak var playerControlButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var EQButton: UIButton!
    var player:Player! = Player()
    
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        //Turn off remote control event delivery
        UIApplication.sharedApplication().endReceivingRemoteControlEvents()
        //resign as first responder to events
        self.resignFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.becomeFirstResponder()
        UIApplication.sharedApplication().beginReceivingRemoteControlEvents()
        
        
    }
    

    
    override func remoteControlReceivedWithEvent(receivedEvent: UIEvent) {
        let rc = receivedEvent.subtype
        println("bp received remote control \(rc.rawValue)")
            // 101 = pause, 100 = play (remote control interface on control center)
            // 103 = playpause (remote control button on earbuds)
        if let p = self.player{
            switch rc{
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
    @IBAction func playControl(sender: AnyObject?) {
        if !self.player!.isPlaying {
            self.playActions()
        }
        else {
            self.pauseActions()
        }
    }
 
    override func shouldPerformSegueWithIdentifier(identifier: String!, sender: AnyObject!) -> Bool {
        if identifier == "RadioToEQSegue" {
        
        // by default, transition
            return true
        }
        else if identifier == "ShowEQSegue"{
            self.containerView.hidden = false
            return true
        }
        else{
            return false
        }
    }
    
    override func prepareForSegue(segue: (UIStoryboardSegue!), sender: AnyObject!) {
        if (segue.identifier == "RadioToEQSegue" || segue.identifier == "ShowEQSegue"){
            
            var svc = segue!.destinationViewController as EQController;
            svc.player = self.player
        }
    }
    
    /* The set of changes made every time player is set to play */
    func playActions(){
        if let p = self.player{
            self.player.isPlaying = true
            if let po = self.player.player{
                self.player.player.playURL(player.fileURL)
            }
        }
        
    self.player.setTitleAndArtist("artist", title: "title")
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
