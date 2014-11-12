//
//  ViewController.swift
//  Chat
//
//  Created by Aleksandr Rogozin on 11/11/14.
//  Copyright (c) 2014 Aleksandr Rogozin. All rights reserved.
//

import UIKit

class ViewController: UIViewController, PNDelegate {

    let pubNubOrigin = "pubsub.pubnub.com"
    let publishKey = "pub-c-313a5d3e-30d7-466b-88e9-3cdac121be5b"
    let subscribeKey = "sub-c-7561326e-6a1f-11e4-b944-02ee2ddab7fe"
    let secretKey = "sec-c-NTk2MzE0NzEtMWY2NS00OTM3LTliYzUtZTAzMDYzZmRhMmYx"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        var configuration: PNConfiguration = PNConfiguration(forOrigin: self.pubNubOrigin, publishKey: self.publishKey, subscribeKey: self.subscribeKey, secretKey: self.secretKey)
        var pubNub:PubNub = PubNub(configuration: configuration, andDelegate: self)
        
        var channel: PNChannel = PNChannel.channelWithName("chat", shouldObservePresence: true) as PNChannel
        pubNub.subscribeOn([channel])
        
        pubNub.sendMessage("hey there", toChannel: channel)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

