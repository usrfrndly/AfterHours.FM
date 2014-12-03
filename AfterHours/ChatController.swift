//
//  ChatController.swift
//  AfterHours
//
//  Created by Aleksandr Rogozin on 12/2/14.
//  Copyright (c) 2014 Aleksandr Rogozin. All rights reserved.
//

import Foundation
import UIKit

class ChatController: UIViewController {
    
    @IBOutlet weak var messagesTableView: UITableView!
    @IBOutlet weak var radioshowLabel: UILabel!
    @IBOutlet weak var djLabel: UILabel!
    @IBOutlet weak var playerControlButton: UIButton!
    var player = Player()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if self.player.isPlaying() {
            var newBackgroundImg = UIImage(named: "Play.png")
            self.playerControlButton.setBackgroundImage(newBackgroundImg, forState: .Normal )
        }
        else {
            var newBackgroundImg = UIImage(named: "Pause.png")
            self.playerControlButton.setBackgroundImage(newBackgroundImg, forState: .Normal )
        }
        
        var firebase = Firebase(url: "https://ahfm.firebaseio.com/playlist")
        firebase.observeEventType(.Value, withBlock: {
            snapshot in
            self.radioshowLabel.text = snapshot.value.objectForKey("title") as String
            self.djLabel.text = snapshot.value.objectForKey("dj") as String
        })

        
    }
    
    @IBAction func playerControlPressed(sender: AnyObject) {
        if self.player.isPlaying(){
            println("\(reflect(self).summary).\(__FUNCTION__)(): Pause stream")
            self.player.pause()
            var newBackgroundImg = UIImage(named: "Play.png")
            self.playerControlButton.setBackgroundImage(newBackgroundImg, forState: .Normal )
        }else{
            println("\(reflect(self).summary).\(__FUNCTION__)(): Play Strean")
            self.player.play()
            var newBackgroundImg = UIImage(named: "Pause.png")
            self.playerControlButton.setBackgroundImage(newBackgroundImg, forState: .Normal)
        }
    }
}
