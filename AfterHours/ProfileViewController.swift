//
//  ProfileViewController.swift
//  AfterHours
//
//  Created by Aleksandr Rogozin on 12/15/14.
//  Copyright (c) 2014 Aleksandr Rogozin. All rights reserved.
//

import Foundation
import UIKit

class ProfileViewController: UIViewController , UITableViewDelegate, UITableViewDataSource{
    
//    
//    {
//    "Las Salinas": {
//    "shows": {
//    "name": "Breaking the Spell",
//    "when": [{
//    "time": "23:00",
//    "day": "Tuesday",
//    "date": "02-02-16"
//    }, {
//    "time": "23:00",
//    "day": "Tuesday",
//    "date": "02-16-16"
//    }],
//    
//    "banner_url": "http://ah.fm/files/djs/las_salinas.jpg"
//    },
//    "location": "Israel",
//    "links": {
//    "Facebook": "https://www.facebook.com/shultz.dj",
//    "Twitter": "https://twitter.com/LasSalinasMusic"
//    }
//    
//    },

    
    var player:Player = Player.sharedInstance
    
    var djs:Firebase!
    let cellIdentifier = "djCell"
    var djsArray:[(name:String, location:String, banner_url:String)] = []
  //  var djsArray:[(name:String, location:String, shows:[String:(banner_url:String, when:[String])])] = []
   // var djsArray:[(name:String ,banner_url:String)] = []

    @IBOutlet var navBarItem: UINavigationItem!
    @IBOutlet weak var radioshowLabel: UILabel!
    @IBOutlet weak var djLabel: UILabel!
    
    @IBOutlet weak var djTableView: UITableView!
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
        
        djs = Firebase(url: "https://ahfm.firebaseio.com/djs")
        djs.observeEventType(.ChildAdded, withBlock: {
            snapshot in
            let name = snapshot.value["name"] as? String
            let location = snapshot.value["location"] as? String
            let s = snapshot.value["shows"]
            print(snapshot.value["shows"]!![ "banner_url"])
          //  let shows = snapshot.value["shows"] as? [String:(banner_url:String, when:[String])]
            
           let banner_url = snapshot.value["shows"]!!["banner_url"] as? String
            self.djsArray.append(name:name!,  location : location!, banner_url: banner_url!)
        })

        
        var img:UIImage? = UIImage(named: "menu.png")
        navBarItem.leftBarButtonItem = UIBarButtonItem(image: img!, style: UIBarButtonItemStyle.Plain , target:self, action: "toggleSideMenuView")
        
        func toggleSideMenu(sender: AnyObject) {
            toggleSideMenuView()
        }
        
        super.viewDidLoad()
        
        //
    }
    
   
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        //self.registerForKeyboardNotifications()
    }
    override func viewWillDisappear(animated: Bool) {
        //self.deregisterFromKeyboardNotifications()
        super.viewWillDisappear(true)
    }
    
    override func viewDidAppear(animated: Bool) {
        self.djTableView.reloadData()
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
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.djsArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var newCell:UITableViewCell?
       var image:UIImage?
        if let cell = tableView.dequeueReusableCellWithIdentifier(self.cellIdentifier) as UITableViewCell!{
            cell.textLabel!.text = "\(self.djsArray[indexPath.row].name)"
            
            let urlPath = NSURL(string:self.djsArray[indexPath.row].banner_url as String)
            do{
                let  imageData:NSData = try NSData(contentsOfURL:urlPath!,options: NSDataReadingOptions.DataReadingMappedIfSafe)
                image = UIImage(data:imageData)!
                cell.imageView?.image = image

               // self.bannerBackground.image = img
                //self.bannerImage.setImage(img, forState: UIControlState.Normal)
            }catch{}
            return cell
            
        }else{
            newCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: self.cellIdentifier)
            let urlPath = NSURL(string:self.djsArray[indexPath.row].banner_url as String)
            do{
                let  imageData:NSData = try NSData(contentsOfURL:urlPath!,options: NSDataReadingOptions.DataReadingMappedIfSafe)
                image = UIImage(data:imageData)!
                // self.bannerBackground.image = img
                //self.bannerImage.setImage(img, forState: UIControlState.Normal)
            }catch{}
            newCell!.imageView?.image = image
            
            newCell!.textLabel!.text = "\(self.djsArray[indexPath.row].name)"
           // print("location : \(self.djsArray[indexPath.row].location)")
            newCell!.detailTextLabel?.text = "\(self.djsArray[indexPath.row].location)"
            
            return newCell!
        }
    }

}