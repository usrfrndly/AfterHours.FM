//
//  MyMenuTableViewController.swift
//  SwiftSideMenu
//
//  Created by Evgeny Nazarov on 29.09.14.
//  Copyright (c) 2014 Evgeny Nazarov. All rights reserved.
//

import UIKit

class MyMenuTableViewController: UITableViewController {
    var selectedMenuItem : Int = 0
    var menuItems = [("DJs",UIImage(named:"djs.png")),("Shows",UIImage(named:"shows.png")),("Events",UIImage(named:"events.png")),("EQ",UIImage(named:"EQ.png"))]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Customize apperance of table view
        tableView.contentInset = UIEdgeInsetsMake(64.0, 0, 0, 0) //
        tableView.separatorStyle = .None
        tableView.backgroundColor = UIColor.clearColor()
        tableView.scrollsToTop = false
        
        // Preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = false
        
        tableView.selectRowAtIndexPath(NSIndexPath(forRow: selectedMenuItem, inSection: 0), animated: false, scrollPosition: .Middle)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return 4 //DJs, Shows, Events, EQ
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("CELL") as? UITableViewCell
        
        if (cell == nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "CELL")
            cell!.backgroundColor = UIColor.clearColor()
           // cell!.textLabel?.textColor = UIColor(red: (46.0/256.0), green: (179.0/255.0), blue: (246.0/255.0), alpha:1.0) //2EB3F6
          
            let selectedBackgroundView = UIView(frame: CGRectMake(0, 0, cell!.frame.size.width, cell!.frame.size.height))
            selectedBackgroundView.backgroundColor = UIColor.grayColor().colorWithAlphaComponent(0.2)
            cell!.selectedBackgroundView = selectedBackgroundView
        }
        configureMenu(cell!, image: menuItems[indexPath.row].1!,text:menuItems[indexPath.row].0)
            //cell!.textLabel?.text = "ViewController #\(indexPath.row+1)"
        
        return cell!
    }
    
//    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        return 50.0
//    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        println("did select row: \(indexPath.row)")
        
        if (indexPath.row == selectedMenuItem){
            return

        }
        selectedMenuItem = indexPath.row

        
        //Present new view controller
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main",bundle: nil)
        var destViewController : UIViewController
        switch (indexPath.row) {
        case 0:
            destViewController = mainStoryboard.instantiateViewControllerWithIdentifier("ViewController1") as UIViewController
            break
        case 1:
            destViewController = mainStoryboard.instantiateViewControllerWithIdentifier("ViewController2") as UIViewController
            break
        case 2:
            destViewController = mainStoryboard.instantiateViewControllerWithIdentifier("ViewController3") as UIViewController
            break
        default:
            destViewController = mainStoryboard.instantiateViewControllerWithIdentifier("ViewController4") as UIViewController
            break
        }
        sideMenuController()?.setContentViewController(destViewController)
    }
    
    func configureMenu(cell:UITableViewCell,image:UIImage,text:String) {
        
        cell.imageView?.image = image
        cell.textLabel?.text = text
        cell.textLabel?.textColor = UIColor.lightTextColor()
        cell.textLabel?.font = UIFont(name: "HelveticaNeue-Bold" ,size: 18.0)
        cell.textLabel?.attributedText
        cell.textLabel?.textAlignment = NSTextAlignment.Right
        
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        var tableHeight = tableView.contentSize.height
        var tableViewFrameHeight = tableView.frame.height
        println(tableHeight)
        println(tableViewFrameHeight)
        println(tableView.sectionHeaderHeight)
        println(tableView.sectionFooterHeight)
        
        return tableViewFrameHeight/4.0 - 44
        
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
