//
//  ChatController.swift
//  AfterHours
//
//  Created by Aleksandr Rogozin on 12/2/14.
//  Copyright (c) 2014 Aleksandr Rogozin. All rights reserved.
//

import Foundation
import UIKit
import CoreImage

class ChatController: UIViewController , UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet var scrollView:UIScrollView!
    @IBOutlet weak var messagesTableView: UITableView!
    @IBOutlet weak var radioshowLabel: UILabel!
    @IBOutlet weak var djLabel: UILabel!
    @IBOutlet weak var playerControlButton: UIButton!
    var player:Player!
    var messages:Firebase!
    let cellIdentifier = "chatCell"
    var chatsArray:[(author:String,text:String)] = []
    @IBOutlet var inputMessageField:UITextField!
    @IBOutlet var messageSendButton: UIButton!
    @IBOutlet var navBarItem: UINavigationItem!

    
    
    var activeField:UITextField?
    
    override func viewDidLoad() {
        
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
            print(snapshot.value)
        })
        //Whether a user is currently typing in the field
        activeField = inputMessageField
        
        var img:UIImage? = UIImage(named: "menu.png")
        navBarItem.leftBarButtonItem = UIBarButtonItem(image: img!, style: UIBarButtonItemStyle.Bordered , target:self, action: "toggleSideMenuView")
        
        
        
        func toggleSideMenu(sender: AnyObject) {
            toggleSideMenuView()
        }

        
        
        //Looks for double taps to dismiss the keyboard
        let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        self.view.addGestureRecognizer(tap)
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.registerForKeyboardNotifications()
    }
    override func viewWillDisappear(animated: Bool) {
        self.deregisterFromKeyboardNotifications()
        super.viewWillDisappear(true)
    }
    
    override func viewDidAppear(animated: Bool) {
        self.messagesTableView.reloadData()
    }
    
    func keyboardWasShown(notification: NSNotification) {
        var info: Dictionary = notification.userInfo!
        var keyboardSize: CGSize = (info[UIKeyboardFrameBeginUserInfoKey]?.CGRectValue.size)!
        var contentInsets = UIEdgeInsetsMake(0.0,0.0,keyboardSize.height,0.0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
        
        //Scroll up if text field is hidden by keyboard
        var aRect:CGRect = self.view.frame
        aRect.size.height -= keyboardSize.height
        if (!CGRectContainsPoint(aRect, self.activeField!.frame.origin) ) {
            self.scrollView.scrollRectToVisible(activeField!.frame, animated: true)
        }
    }
    
    
    func keyboardWillBeHidden(notification: NSNotification) {
        //self.scrollView.setContentOffset(CGPointZero, animated: true)
        let contentInsets:UIEdgeInsets = UIEdgeInsetsZero
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
    
    // track the activeField to see the current editing status
    func textFieldDidBeginEditing(textField:UITextField){
        activeField = textField;
    }
    
    func textFieldDidEndEditing(textField:UITextField){
        activeField = nil
        self.scrollView.setContentOffset(CGPointMake(0, 0), animated:true);
    }
    
    @IBAction func playerControlPressed(sender: AnyObject) {
        if self.player.isPlaying(){
            print("\(Mirror(reflecting: self).description).\(__FUNCTION__)(): Pause stream")
            self.player.pause()
            let newBackgroundImg = UIImage(named: "Play.png")
            self.playerControlButton.setBackgroundImage(newBackgroundImg, forState: .Normal )
        }else{
            print("\(Mirror(reflecting:self).description).\(__FUNCTION__)(): Play Strean")
            self.player.play()
            let newBackgroundImg = UIImage(named: "Pause.png")
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
        var newCell:UITableViewCell?
        if let cell = tableView.dequeueReusableCellWithIdentifier(self.cellIdentifier) as UITableViewCell!{
            cell.textLabel!.text = "\(self.chatsArray[indexPath.row].text)"
            return cell
            
        }else{
            newCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: self.cellIdentifier)
            
            
            let image = UIImage(named: "hat-guy.png")
            newCell!.imageView?.image = image
            newCell!.textLabel!.text = "\(self.chatsArray[indexPath.row].text)"
            newCell!.detailTextLabel?.text = "\(self.chatsArray[indexPath.row].author)"
            
            return newCell!
        }
    }
    //MARK: Keyboard Avoidance
    func registerForKeyboardNotifications() -> Void {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWasShown:", name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWasShown:", name: UIKeyboardWillShowNotification, object: nil)
        
    }
    
    func deregisterFromKeyboardNotifications() -> Void {
        print("Deregistering!")
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWasShown:", name: UIKeyboardDidHideNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWasShown:", name: UIKeyboardWillHideNotification, object: nil)
        
    }
    
    
    //Calls this function when the tap is recognized.
    func DismissKeyboard(){
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        inputMessageField.resignFirstResponder()
    }
    
    
}


