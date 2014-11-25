//
//  NowPlayingController.swift
//  AfterHours
//
//  Created by Jaclyn May on 11/25/14.
//  Copyright (c) 2014 Aleksandr Rogozin. All rights reserved.
//


import Foundation
import UIKit

class NowPlayingController:UIViewController{
    var player:Player!
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
    }
    
    override init(nibName: String?, bundle: NSBundle?) {
        super.init(nibName: nibName,bundle: bundle)
        //Custom Initialization when we need it
        
    }
    
    override func viewDidLoad() {
        NSLog("\(__FILE__).\( __FUNCTION__)")
        
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
}