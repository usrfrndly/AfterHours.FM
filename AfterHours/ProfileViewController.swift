//
//  ProfileViewController.swift
//  AfterHours
//
//  Created by Aleksandr Rogozin on 12/15/14.
//  Copyright (c) 2014 Aleksandr Rogozin. All rights reserved.
//

import Foundation
import UIKit

class ProfileViewController: UIViewController {
     var player:Player = Player.sharedInstance
    @IBOutlet var navBarItem: UINavigationItem!
    @IBOutlet weak var radioshowLabel: UILabel!
    @IBOutlet weak var djLabel: UILabel!
    @IBAction func playlistPressed(sender: AnyObject) {
    }
    @IBOutlet weak var togglePlayButton: UIButton!
  
    override func viewDidLoad() {
        if(player.isPlaying()){
            let newBackgroundImg = UIImage(named: "Pause.png")
            self.togglePlayButton.setBackgroundImage(newBackgroundImg, forState: .Normal)
        }else{
            let newBackgroundImg = UIImage(named: "Play.png")
            self.togglePlayButton.setBackgroundImage(newBackgroundImg, forState: .Normal )
        }
        let firebase = Firebase(url: "https://ahfm.firebaseio.com/playlist")
        firebase.observeEventType(.Value, withBlock: {
            snapshot in
            self.radioshowLabel.text = snapshot.value.objectForKey("title") as? String
            self.djLabel.text = snapshot.value.objectForKey("dj") as? String
        })
        
        var img:UIImage? = UIImage(named: "menu.png")
        navBarItem.leftBarButtonItem = UIBarButtonItem(image: img!, style: UIBarButtonItemStyle.Plain , target:self, action: "toggleSideMenuView")
        
        func toggleSideMenu(sender: AnyObject) {
            toggleSideMenuView()
        }
        
        //
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
}