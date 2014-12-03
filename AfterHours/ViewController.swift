//
//  ViewController.swift
//  AfterHours
//
//  Created by Aleksandr Rogozin on 11/25/14.
//  Copyright (c) 2014 Aleksandr Rogozin. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {
    var player:Player! = Player.sharedInstance
    
    @IBOutlet var togglePlayButton: UIButton!
    @IBOutlet weak var bannerImage: UIButton!
    @IBOutlet weak var bannerBackground: UIImageView!
    @IBOutlet weak var radioshowLabel: UILabel!
    @IBOutlet weak var djLabel: UILabel!
    
    override func viewDidLoad() {
        println("\(reflect(self).summary).\(__FUNCTION__):")
        if player.isPlaying(){
            var newBackgroundImg = UIImage(named: "Play.png")
            self.togglePlayButton.setBackgroundImage(newBackgroundImg, forState: .Normal )
        }

        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        Alamofire.request(.GET, "http://httpbin.org/get")
            .responseJSON { (_, _, JSON, _) in
                println(JSON)
        }
        
        var firebase = Firebase(url: "https://ahfm.firebaseio.com/playlist")
        firebase.observeEventType(.Value, withBlock: {
            snapshot in
            self.radioshowLabel.text = snapshot.value.objectForKey("title") as String
            self.djLabel.text = snapshot.value.objectForKey("dj") as String
            
            let urlPath = NSURL(string:snapshot.value.objectForKey("banner") as String)
            var err: NSError?
            var imageData :NSData = NSData(contentsOfURL:urlPath!,options: NSDataReadingOptions.DataReadingMappedIfSafe, error: &err)!
            var img:UIImage = UIImage(data:imageData)!
            
            self.bannerBackground.image = img
            self.bannerImage.setImage(img, forState: UIControlState.Normal)
            //self.player.updatePlayerInfo(snapshot.value.objectForKey("dj") as String, title: snapshot.value.objectForKey("title") as String, imageUrl: snapshot.value.objectForKey("banner") as String)
        })
        
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

