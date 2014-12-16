//
//  ViewController.swift
//  AfterHours
//
//  Created by Aleksandr Rogozin on 11/25/14.
//  Copyright (c) 2014 Aleksandr Rogozin. All rights reserved.
//

/*
Due to the current lack of proper infrastructure for Swift dependency management, using Alamofire in your project requires the following steps:

Add Alamofire as a submodule by opening the Terminal, cd-ing into your top-level project directory, and entering the command git submodule add https://github.com/Alamofire/Alamofire.git
Open the Alamofire folder, and drag Alamofire.xcodeproj into the file navigator of your app project.
In Xcode, navigate to the target configuration window by clicking on the blue project icon, and selecting the application target under the "Targets" heading in the sidebar.
Ensure that the deployment target of Alamofire.framework matches that of the application target.
In the tab bar at the top of that window, open the "Build Phases" panel.
Expand the "Target Dependencies" group, and add Alamofire.framework.
Click on the + button at the top left of the panel and select "New Copy Files Phase". Rename this new phase to "Copy Frameworks", set the "Destination" to "Frameworks", and add Alamofire.framework.
*/

import UIKit
import Alamofire

class ViewController: UIViewController{
    var player:Player! = Player.sharedInstance

    @IBOutlet var togglePlayButton: UIButton!
    @IBOutlet weak var bannerImage: UIButton!
    @IBOutlet weak var bannerBackground: UIImageView!
    @IBOutlet weak var radioshowLabel: UILabel!
    @IBOutlet weak var djLabel: UILabel!
    @IBOutlet var navBarItem: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        println("\(reflect(self).summary).\(__FUNCTION__):")
        if player.isPlaying(){
            var newBackgroundImg = UIImage(named: "Play.png")
            self.togglePlayButton.setBackgroundImage(newBackgroundImg, forState: .Normal )
        }
        
        Alamofire.request(.GET, "http://httpbin.org/get")
            .responseJSON { (_, _, JSON, _) in
                println(JSON)
        }
        
        var firebase = Firebase(url: "https://ahfm.firebaseio.com/playlist")
        firebase.observeEventType(.Value, withBlock: {
            snapshot in
            self.radioshowLabel.text = snapshot.value.objectForKey("title") as? String
            self.djLabel.text = snapshot.value.objectForKey("dj") as? String
            
            let urlPath = NSURL(string:snapshot.value.objectForKey("banner") as String)
            var err: NSError?
            var imageData :NSData = NSData(contentsOfURL:urlPath!,options: NSDataReadingOptions.DataReadingMappedIfSafe, error: &err)!
            var img:UIImage = UIImage(data:imageData)!
            
            self.bannerBackground.image = img
            self.bannerImage.setImage(img, forState: UIControlState.Normal)
            //self.player.updatePlayerInfo(snapshot.value.objectForKey("dj") as String, title: snapshot.value.objectForKey("title") as String, imageUrl: snapshot.value.objectForKey("banner") as String)
        })
        
        //self.player.updatePlayerInfo("John Doe", title: "Testin 123", imageUrl: "http://dev.ah.fm/assets/default.png")
        var img:UIImage? = UIImage(named: "menu.png")
        navBarItem.leftBarButtonItem = UIBarButtonItem(image: img!, style: UIBarButtonItemStyle.Bordered , target:self, action: "toggleSideMenuView")
        
    }
    
    @IBAction func toggleSideMenu(sender: AnyObject) {
        toggleSideMenuView()
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
            var newBackgroundImg = UIImage(named: "Pause.png")
            self.togglePlayButton.setBackgroundImage(newBackgroundImg, forState: .Normal)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}

