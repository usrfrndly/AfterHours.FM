//
//  RadioShowController.swift
//  AfterHours
//
//  Created by Aleksandr Rogozin on 12/15/14.
//  Copyright (c) 2014 Aleksandr Rogozin. All rights reserved.
//

import Foundation
import UIKit

class RadioShowController: UIViewController {
    @IBAction func playlistPressed(sender: AnyObject) {
    }
    @IBOutlet weak var playButton: UIButton!
    @IBAction func playButtonPressed(sender: AnyObject) {
    }

    @IBOutlet weak var radioshowLabel: UILabel!
    @IBOutlet weak var djLabel: UILabel!
    
    override func viewDidLoad() {
        var firebase = Firebase(url: "https://ahfm.firebaseio.com/playlist")
        firebase.observeEventType(.Value, withBlock: {
            snapshot in
            self.radioshowLabel.text = snapshot.value.objectForKey("title") as? String
            self.djLabel.text = snapshot.value.objectForKey("dj") as? String
        })

    }
}