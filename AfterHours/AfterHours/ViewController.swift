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
        var request = NSMutableURLRequest(URL: NSURL(string: "http://dev.ah.fm/omgapi/show")!)
        var session = NSURLSession.sharedSession()
        request.HTTPMethod = "POST"
        
        var params = ["show":"derp"] as Dictionary
        var err: NSError?
        
        request.HTTPBody = NSJSONSerialization.dataWithJSONObject(params, options: nil, error: &err)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        var task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            
            println("Response: \(response)")
            
            var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
            
            println("Body: \(strData)\n\n")
            
            var err: NSError?
            
            var json = NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves, error: &err) as NSDictionary
            
            println(json["show"])
        })
        
        task.resume()

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

