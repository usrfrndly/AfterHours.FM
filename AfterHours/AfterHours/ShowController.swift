//
//  ShowController.swift
//  AfterHours
//
//  Created by Aleksandr Rogozin on 11/22/14.
//  Copyright (c) 2014 Aleksandr Rogozin. All rights reserved.
//

import Foundation

class Show {
    
    let apiUrl = "http://dev.ah.fm/omgapi/show"
    
    func getShowInfo(showTitle: String) -> Dictionary<String, String> {
        var showInfo = Dictionary<String, String>()
        var request = NSMutableURLRequest(URL: NSURL(string: self.apiUrl)!)
        var session = NSURLSession.sharedSession()
        request.HTTPMethod = "POST"
        
        var params = ["showTitle": showTitle] as Dictionary
        var err: NSError?
        
        request.HTTPBody = NSJSONSerialization.dataWithJSONObject(params, options: nil, error: &err)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        showInfo["derp"] = "derper"
        var task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            //println("Response: \(response)")
            var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
            var err: NSError?
            var json = NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves, error: &err) as NSDictionary
            //println("Body: \(strData)\n\n")
            if(err != nil) {
                println(err!.localizedDescription)
                let jsonStr = NSString(data: data, encoding: NSUTF8StringEncoding)
                println("Error could not parse JSON: '\(jsonStr)'")
            }
            showInfo["showTitle"] = "test"
            //println(json["showTitle"])
        })
        
        task.resume()
        return showInfo
    }

}