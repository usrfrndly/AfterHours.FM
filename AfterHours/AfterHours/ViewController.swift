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
    
    @IBOutlet var radioShowLabel: UILabel!
    @IBOutlet var djLabel: UILabel!
    
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

    /* The set of changes made every time player is set to play */
    func playActions(){
        if let p = self.player {
            self.player.isPlaying = true
            if let po = self.player.player{
                self.player.player.playURL(player.fileURL)
            }
        }
        
        self.player.setTitleAndArtistAndImage(self.player.dj, title: self.player.show, url: self.player.banner)
        
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
            
            self.radioShowLabel.text = self.player.show
            self.djLabel.text = self.player.dj
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

}

