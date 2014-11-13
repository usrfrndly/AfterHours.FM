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
    let publishKey = "pub-49c6dcfd-8130-49a4-97ae-e9bc33dcac74"
    let subscribeKey = "sub-b81d21de-a303-11e1-abf1-6b2382a11c77"
    let secretKey = "sec-ZGJjZjQxYjQtNWRiMi00MTcyLTk1NTUtYWVmNjBmZTI0NmNj"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        var configuration: PNConfiguration = PNConfiguration(forOrigin: self.pubNubOrigin, publishKey: self.publishKey, subscribeKey: self.subscribeKey, secretKey: self.secretKey)
        var pubNub:PubNub = PubNub(configuration: configuration, andDelegate: self)
        
        var channel: PNChannel = PNChannel.channelWithName("chat", shouldObservePresence: true) as PNChannel
        pubNub.subscribeOn([channel])

        pubNub.connect()

        pubNub.sendMessage("hey there", toChannel: channel)
        
        if (pubNub.isConnected()) {
            println("[PubNub] Connected.")
            
        }
        else {
            println("[PubNub] Not Connected.")
        }
        
        pubNub.observationCenter.addMessageReceiveObserver(self, withBlock: { (PNMessage) -> Void in
            println(PNMessage.message)
        })
        
        //PNObservationCenter.addMessageReceiveObserver(PNObservationCenter.defaultCenter())
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func pubnubClient(client: PubNub!, didReceiveMessage message: PNMessage!) {
        println("\(message.message)")
    }
}

