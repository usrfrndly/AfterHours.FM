//
//  ViewController.swift
//  AfterHours
//
//  Created by Aleksandr Rogozin on 11/19/14.
//  Copyright (c) 2014 Aleksandr Rogozin. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer

struct Message {
    let author : String
    let text : String
}

class ViewController: UIViewController {
    @IBOutlet var playerControlButton: UIButton!
    @IBOutlet var radioShowTitle: UILabel!
    @IBOutlet var radioShowDJ: UILabel!
    @IBOutlet var radioShowBackground: UIImageView!
    @IBOutlet var radioShowBanner: UIButton!


  
    /// View Container that contains whatever is beneath the radio, such as the EQ
    @IBOutlet weak var containerView: UIView!
    /// EQ button to show EQ. Only shown when player is playing.
    @IBOutlet weak var EQButton: UIButton?
    
    /// Instance of the Player class
    var player:Player! = Player()
    
    // Instance of container view controller
    var containerViewController:ContainerViewController!
    
    
    /**
    Enables running the app in the background
    */
    override func canBecomeFirstResponder() -> Bool {
        println("ViewController.canBecomeFirstResponder()")
        return true
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        //Turn off remote control event delivery
        UIApplication.sharedApplication().endReceivingRemoteControlEvents()
        //resign as first responder to events
        self.resignFirstResponder()
    }
    

    
    /**
    Responds to events to control player
    
    :param: receivedEvent The type of event used to control the player
    */
    override func remoteControlReceivedWithEvent(receivedEvent: UIEvent) {
        let eventType = receivedEvent.subtype
        println("View Controller received remote control  type \(eventType.rawValue)")
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
    
    :param: identifier The segue identifier
    :param: sender     What called the segue
    
    :returns: Whether the View controller should segue
    */
    override func shouldPerformSegueWithIdentifier(identifier: String!, sender: AnyObject!) -> Bool {

        NSLog("\(__FILE__).\( __FUNCTION__)")
        return true
        
        
        
    }
    
    /**
    Prepares for segue to show EQ  view and passes the player instance to this
    new view
    
    :param: segue  The segue to te EQ
    :param: sender sender
    */
    override func prepareForSegue(segue: (UIStoryboardSegue!), sender: AnyObject!) {
        NSLog("\(__FILE__).\( __FUNCTION__)")
        if (segue.identifier == "embedContainer"){
            self.containerViewController = segue.destinationViewController as ContainerViewController
            containerViewController.player = self.player
            //var svc = segue!.destinationViewController as EQViewController;
            //svc.player = self.player
        }
    }
    
    /* The set of changes made every time player is made to play */
    func playActions(){
        if let p = self.player {
            self.player.isPlaying = true
            if let po = self.player.player{
                self.player.player.playURL(player.fileURL)
            }
        }
        
        self.player.setTitleAndArtistAndImage(self.player.dj, title: self.player.show, imageUrl: self.player.banner)
        var pause_img = UIImage(named: "Pause_button")
        self.playerControlButton.setBackgroundImage(pause_img,forState:UIControlState.Normal)
        if let eq_btn = self.EQButton{
            
            self.EQButton!.hidden = false
        }
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
        var play_img = UIImage(named: "Play")
        self.playerControlButton.setBackgroundImage(play_img,forState:UIControlState.Normal)
        if let eq_btn = self.EQButton{
            self.EQButton!.hidden = true
        }
    }
    
    @IBAction func showEQ(sender: AnyObject) {
        self.containerViewController.swapViewControllers()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.becomeFirstResponder()
        UIApplication.sharedApplication().beginReceivingRemoteControlEvents()
        // Do any additional setup after loading the view, typically from a nib.
        var firebase = Firebase(url: "https://ahfm.firebaseio.com/playlist")
        
        firebase.observeEventType(.Value, withBlock: { snapshot in
            //println(snapshot.value.objectForKey("playlist"))
            //println("\(snapshot.key) -> \(snapshot.value)")
            println(snapshot.value.objectForKey("title"))
            self.player.show = snapshot.value.objectForKey("title") as String
            self.player.dj = snapshot.value.objectForKey("dj") as String
            self.player.banner = snapshot.value.objectForKey("banner") as String
            
            self.radioShowTitle.text = self.player.show
            self.radioShowDJ.text = self.player.dj
        })
        
        /*
        Agent.post("http://dev.ah.fm/omgapi/show")
            .send([ "title": "Jordan Suckley - Goodgreef Radio 059 on AH.FM 13-10-2013" ])
            .end({ (response: NSHTTPURLResponse!, data: Agent.Data!, error: NSError!) -> Void in
                // react to the result of your request
                println(data)
            }
        )
        */
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

