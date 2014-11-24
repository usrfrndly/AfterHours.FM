//
//  ChatController.swift
//  AfterHours
//
//  Created by Aleksandr Rogozin on 11/23/14.
//  Copyright (c) 2014 Aleksandr Rogozin. All rights reserved.
//

import Foundation
import UIKit

class ChatController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var chatTableView: UITableView!
    @IBOutlet var textField: UITextField!
    @IBOutlet var sendButton: UIButton!
    
    @IBAction func sendButtonPressed(sender: AnyObject) {
        // Work with text only. Ignore empty textfield.
        if (self.textField.text != "") {
            // Put value of textfield into variable
            var message = self.textField.text
            // Reset value of textfield
            self.textField.text = ""
        
            println(message)
            
            // Prepare message for firebase
            var firebaseMessage = ["author": "guest", "text": message]
            // Put auto id for the message
            var firebaseMessageRef = firebase.childByAutoId()
            // Post the message
            firebaseMessageRef.setValue(firebaseMessage)
        }
    }
    
    var firebase: Firebase = Firebase(url: "https://ahfm.firebaseio.com/messages")
    var messages = ["hello", "world"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.firebase.observeEventType(.Value, withBlock: {
            snapshot in
            println(snapshot.value)
        })
        
        
        self.chatTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.chatTableView.dataSource = self
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell = self.chatTableView.dequeueReusableCellWithIdentifier("cell") as UITableViewCell
        cell.textLabel.text = self.messages[indexPath.row]
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messages.count
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

