//
//  ProfileViewController.swift
//  AfterHours
//
//  Created by Aleksandr Rogozin on 12/15/14.
//  Copyright (c) 2014 Aleksandr Rogozin. All rights reserved.
//

import Foundation
import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet var navBarItem: UINavigationItem!
    override func viewDidLoad() {
        
        var img:UIImage? = UIImage(named: "menu.png")
        navBarItem.leftBarButtonItem = UIBarButtonItem(image: img!, style: UIBarButtonItemStyle.Bordered , target:self, action: "toggleSideMenuView")
        
        func toggleSideMenu(sender: AnyObject) {
            toggleSideMenuView()
        }
        
        //
    }
}