//
//  ViewController.swift
//  AfterHours
//
//  Created by Aleksandr Rogozin on 11/19/14.
//  Copyright (c) 2014 Aleksandr Rogozin. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var messagesTableView: UITableView!
    
    var arrItems = ["IOS" , "Developer","Cloud"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        var firebase = Firebase(url: "https://ahfm.firebaseio.com/")

        firebase.observeEventType(.Value, withBlock: { snapshot in
            println(snapshot.value.objectForKey("playlist"))
            //println("\(snapshot.key) -> \(snapshot.value)")
        })
        
        self.messagesTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int{
        return 10
    }
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell{
        let tableCell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "Cell")
        tableCell.text = "Title of Row: #\(indexPath.row)"
        tableCell.detailTextLabel.text = "Detail of Row: #\(indexPath.row)"
        return tableCell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

