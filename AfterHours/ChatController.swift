//
//  ChatController.swift
//  AfterHours
//
//  Created by Aleksandr Rogozin on 12/2/14.
//  Copyright (c) 2014 Aleksandr Rogozin. All rights reserved.
//

import Foundation
import UIKit

class ChatController: UIViewController , UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var messagesTableView: UITableView!
    @IBOutlet weak var radioshowLabel: UILabel!
    @IBOutlet weak var djLabel: UILabel!
    @IBOutlet weak var playerControlButton: UIButton!
    var player:Player!
    var messages:Firebase!
    var chatsArray:[(author:String,text:String)] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
//        if self.player.isPlaying() {
//            var newBackgroundImg = UIImage(named: "Play.png")
//            self.playerControlButton.setBackgroundImage(newBackgroundImg, forState: .Normal )
//        }
//        else {
//            var newBackgroundImg = UIImage(named: "Pause.png")
//            self.playerControlButton.setBackgroundImage(newBackgroundImg, forState: .Normal )
//        }

        
        var firebase = Firebase(url: "https://ahfm.firebaseio.com/playlist")
        firebase.observeEventType(.Value, withBlock: {
            snapshot in
            self.radioshowLabel.text = snapshot.value.objectForKey("title") as? String
            self.djLabel.text = snapshot.value.objectForKey("dj") as? String
        })

        messages = Firebase(url: "https://ahfm.firebaseio.com/messages")
        messages.observeEventType(.ChildAdded, withBlock: {
            (snapshot) in
            let author = snapshot.value["author"] as? String
            let text = snapshot.value["text"] as? String
            self.chatsArray.append(author:author!, text:text!)
            println(snapshot.value)

        
        })
        
            self.messagesTableView.registerClass(UITableViewCell.classForCoder(),
            forCellReuseIdentifier: "chatCell")
            self.messagesTableView.dataSource = self
            self.messagesTableView.delegate = self
            self.messagesTableView.autoresizingMask = .FlexibleWidth | .FlexibleHeight
            view.addSubview(self.messagesTableView)
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
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.chatsArray.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("chatCell", forIndexPath: indexPath) as UITableViewCell

//        UIImage image = UIImage(named: "headphone-icon.png")
        cell.textLabel!.text = "\(self.chatsArray[indexPath.row].text)"
        cell.detailTextLabel?.text = "\(self.chatsArray[indexPath.row].author)"

        return cell
    }
}
