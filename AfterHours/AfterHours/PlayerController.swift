//
//  PlayerController.swift
//  AfterHours
//
//  Created by Aleksandr Rogozin on 11/23/14.
//  Copyright (c) 2014 Aleksandr Rogozin. All rights reserved.
//

import Foundation

private let _PlayerSharedInstance = Player()

class Player {
    
    class var sharedInstance : Player {
        return _PlayerSharedInstance
    }
    
    var show: String = "Radio Show"
    var dj: String = "DJ Name"
    var banner: String = "http://dev.ah.fm/assets/default.jpg"

    
    
}