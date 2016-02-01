//
//  RadioShowController.swift
//  AfterHours
//
//  Created by Aleksandr Rogozin on 12/15/14.
//  Copyright (c) 2014 Aleksandr Rogozin. All rights reserved.
//

import Foundation
import UIKit

class RadioShowController: UIViewController {
  var player:Player = Player.sharedInstance
    @IBAction func playlistPressed(sender: AnyObject) {
    }
    @IBOutlet weak var playButton: UIButton!
    @IBAction func playButtonPressed(sender: AnyObject) {
        //let playerStateValue = self.player.getPlayerState()
        //println("Player state value: \(self.player.player.state.value)")
        if self.player.isPlaying(){
            print("\(Mirror(reflecting:self).description).\(__FUNCTION__)(): Pause stream")
            self.player.pause()
            let newBackgroundImg = UIImage(named: "Play.png")
            self.playButton.setBackgroundImage(newBackgroundImg, forState: .Normal )
        }else{
            print("\(Mirror(reflecting:self).description).\(__FUNCTION__)(): Play Strean")
            self.player.play()
            let newBackgroundImg = UIImage(named: "Pause.png")
            self.playButton.setBackgroundImage(newBackgroundImg, forState: .Normal)
        }
    
    }

    @IBOutlet var navBarItem: UINavigationItem!
    @IBOutlet weak var radioshowLabel: UILabel!
    @IBOutlet weak var djLabel: UILabel!
    
    override func viewDidLoad() {
        if(player.isPlaying()){
            let newBackgroundImg = UIImage(named: "Pause.png")
            self.playButton.setBackgroundImage(newBackgroundImg, forState: .Normal)
        }else{
            let newBackgroundImg = UIImage(named: "Play.png")
            self.playButton.setBackgroundImage(newBackgroundImg, forState: .Normal )
        }
        
        let firebase = Firebase(url: "https://ahfm.firebaseio.com/playlist")
        firebase.observeEventType(.Value, withBlock: {
            snapshot in
            self.radioshowLabel.text = snapshot.value.objectForKey("title") as? String
            self.djLabel.text = snapshot.value.objectForKey("dj") as? String
        })
        
        let img:UIImage? = UIImage(named: "menu.png")
        navBarItem.leftBarButtonItem = UIBarButtonItem(image: img!, style: UIBarButtonItemStyle.Bordered , target:self, action: "toggleSideMenuView")
        
    }
    
    @IBAction func toggleSideMenu(sender: AnyObject) {
        toggleSideMenuView()
    }


    }

