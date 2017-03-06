//
//  WebService.swift
//  Bowden
//
//  Created by Dustin Allen on 1/8/16.
//  Copyright © 2016 BareLabor. All rights reserved.
//

import UIKit

class WebServiceObject: NSObject {
    
    static let BASE_URL = "http://barelabor.com"
    static let API_PATH = "/barelabor/api"
    
    // delcare URL
    static let getEstimatesURL = "/index.php?method=getEstimates"                  // for GET ESTIMATES
    
    
    // Post Request
    static func postRequest(_ url: String, requestDict: Dictionary<String, String?>, completionHandler: @escaping ((AnyObject?, AnyObject?, NSError?) -> Void)) {
        
        // create request data
        let urlString = "\(BASE_URL)\(API_PATH)\(url)"
        let requestURL = URL(string: urlString)
        let request = NSMutableURLRequest(url: requestURL!)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        //
        var firstOneAdded = false
        var contentBodyAsString = ""
        let contentKeys: Array<String> = Array(requestDict.keys)
        
        for contentKey in contentKeys {
            if (!firstOneAdded) {
                contentBodyAsString += contentKey + "=" + requestDict[contentKey]!!
                firstOneAdded = true
            } else {
                contentBodyAsString += "&" + contentKey + "=" + requestDict[contentKey]!!
            }
        }
        
        request.httpBody = contentBodyAsString.data(using: String.Encoding.utf8)
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: {data, response, error -> Void in
            do {
                let jsonData = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                completionHandler(jsonData, response, error)
            } catch {
            }
        }) 
        task.resume()
    }
    
    
}
