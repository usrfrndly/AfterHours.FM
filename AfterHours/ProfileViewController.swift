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

    var player:Player! = Player.sharedInstance
    @IBAction func playlistPressed(sender: AnyObject) {
    }
    @IBOutlet var navBarItem: UINavigationItem!
    @IBOutlet weak var djLabel: UILabel!
    @IBOutlet weak var radioshowLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    @IBAction func playButtonPressed(sender: AnyObject) {
        if self.player.isPlaying(){
            println("\(reflect(self).summary).\(__FUNCTION__)(): Pause stream")
            self.player.pause()
            var newBackgroundImg = UIImage(named: "Pause.png")
            self.playButton.setBackgroundImage(newBackgroundImg, forState: .Normal )
        }else{
            println("\(reflect(self).summary).\(__FUNCTION__)(): Play Strean")
            self.player.play()
            var newBackgroundImg = UIImage(named: "Play.png")
            self.playButton.setBackgroundImage(newBackgroundImg, forState: .Normal)
        }
    }


    override func viewDidLoad() {
        var firebase = Firebase(url: "https://ahfm.firebaseio.com/playlist")
        firebase.observeEventType(.Value, withBlock: {
            snapshot in
            self.radioshowLabel.text = snapshot.value.objectForKey("title") as? String
            self.djLabel.text = snapshot.value.objectForKey("dj") as? String
        })
        if self.player.isPlaying(){
            println("\(reflect(self).summary).\(__FUNCTION__)(): Pause stream")
var newBackgroundImg = UIImage(named: "Pause.png")
            self.playButton.setBackgroundImage(newBackgroundImg, forState: .Normal )
}else{
println("\(reflect(self).summary).\(__FUNCTION__)(): Play Strean")
            var newBackgroundImg = UIImage(named: "Play.png")
self.playButton.setBackgroundImage(newBackgroundImg, forState: .Normal)
        
}
        var img:UIImage? = UIImage(named: "menu.png")

        navBarItem.leftBarButtonItem = UIBarButtonItem(image: img!, style: UIBarButtonItemStyle.Bordered , target:self, action: "toggleSideMenuView")

        
        func toggleSideMenu(sender: AnyObject) {
            toggleSideMenuView()
        }
        

    }
}
