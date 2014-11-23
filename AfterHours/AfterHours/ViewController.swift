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
    
    @IBOutlet weak var messagesTableView: UITableView!
    
    var messages = [Message] ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        /*
        var firebase = Firebase(url: "https://ahfm.firebaseio.com/")
        
        firebase.observeEventType(.Value, withBlock: { snapshot in
            println(snapshot.value.objectForKey("playlist"))
            //println("\(snapshot.key) -> \(snapshot.value)")
        })
        */
        Agent.post("http://dev.ah.fm/omgapi/show")
            .send([ "showTitle": "Jordan Suckley - Goodgreef Radio 059 on AH.FM 13-10-2013" ])
            .end({ (response: NSHTTPURLResponse!, data: Agent.Data!, error: NSError!) -> Void in
                // react to the result of your request
                println(data)
            }
        )
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

