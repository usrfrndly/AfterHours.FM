//
//  ViewController.swift
//  AfterHours
//
//  Created by Aleksandr Rogozin on 11/25/14.
//  Copyright (c) 2014 Aleksandr Rogozin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var player:Player! = Player.sharedInstance
    
    @IBOutlet var togglePlayButton: UIButton!
    
    override func viewDidLoad() {
        println("\(reflect(self).summary).\(__FUNCTION__):")
        if player.isPlaying(){
            var newBackgroundImg = UIImage(named: "Play.png")
            self.togglePlayButton.setBackgroundImage(newBackgroundImg, forState: .Normal )
        }

        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //self.player.updatePlayerInfo("John Doe", title: "Testin 123", imageUrl: "http://dev.ah.fm/assets/default.png")
        
    }
    
    @IBAction func togglePlayButtonPressed(sender: UIButton?){
        //let playerStateValue = self.player.getPlayerState()
        //println("Player state value: \(self.player.player.state.value)")
        if self.player.isPlaying(){
            println("\(reflect(self).summary).\(__FUNCTION__)(): Pause stream")
            self.player.pause()
            var newBackgroundImg = UIImage(named: "Play.png")
            self.togglePlayButton.setBackgroundImage(newBackgroundImg, forState: .Normal )
        }else{
            println("\(reflect(self).summary).\(__FUNCTION__)(): Play Strean")
            self.player.play()
            var newBackgroundImg = UIImage(named: "Pause_button.png")
            self.togglePlayButton.setBackgroundImage(newBackgroundImg, forState: .Normal)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

