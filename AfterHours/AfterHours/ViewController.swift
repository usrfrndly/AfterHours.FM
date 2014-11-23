//
//  ViewController.swift
//  AfterHours
//
//  Created by Aleksandr Rogozin on 11/19/14.
//  Copyright (c) 2014 Aleksandr Rogozin. All rights reserved.
//

import UIKit

struct Message {
    let author : String
    let text : String
}

class ViewController: UIViewController {
    
    @IBOutlet var radioShowLabel: UILabel!
    @IBOutlet var djLabel: UILabel!
    
    var player = Player()
    
    override func viewDidLoad() {
        super.viewDidLoad()
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

