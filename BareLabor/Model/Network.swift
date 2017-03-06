//
//  Network.swift
//  BareLabor
//
//  Dustin Allen
//  Copyright © 2016 BareLabor. All rights reserved.
//

import UIKit
import Alamofire
import Foundation

class Network: NSObject {
    
    class var sharedInstance: Network {
        
        struct Singleton {
            static let instance = Network()
        }
        return Singleton.instance
    }
    
    // Base URL String
    static let baseURLString = "http://barelabor.com/"
    
    // Registration URL String
    static let registrationURLString = baseURLString + "barelabor/api/index.php?method=register"
    
    // Login URL String
    static let loginURLString = baseURLString + "barelabor/api/index.php?method=login"
    
    // Get Make from Year URL String
    static let getMakeURLString = baseURLString + "barelabor/api/index.php?method=getMake"
    
    // Get Model URL String
    static let getModelURLString = baseURLString + "barelabor/api/index.php?method=getModel"
    
    // Get Features URL String
    static let getFeaturesURLString = baseURLString + "barelabor/api/index.php?method=getFeatures"
    
    // Get price by vehicle URL String
    static let getVehiclePrice = baseURLString + "barelabor/api/index.php?method=getPriceByVehicle"
    
    // Get price by size URL String
    static let getSizePrice = baseURLString + "barelabor/api/index.php?method=getPriceBySize"
    
    // SubmitExpirience URL String
    static let submitExperience = baseURLString + "barelabor/api/index.php?method=submitExperience"

	// SubmitEstimate URL String
	static let submitEstimate = baseURLString + "barelabor/api/index.php?method=submitEstimate"
	
    // GetEstimate URL String
    static let getEstimate = baseURLString + "barelabor/api/index.php?method=getEstimates"
    
	// Get neares locations list by user location
    static let getNearestLocations = baseURLString + "barelabor/api/index.php?method=findNearShop"
    
    // Headers JSON
    static let URLHeaders = ["Content-Type" : "application/json", "Accept" : "application/json"]
    
    
    func get(_ url: String, parameters: [String: AnyObject]? = nil, completionHandler: @escaping (_ data : AnyObject?) -> ()){
        
        Alamofire.request(.GET, url, parameters: parameters, encoding: .json, headers: Network.URLHeaders).responseJSON(options: JSONSerialization.ReadingOptions.allowFragments) { (_, _, result) -> Void in
            
            switch result {
            case .success(let data):
                completionHandler(data: data)
            case .failure(_, let error):
                print("Request failed with error: \(error)")
                completionHandler(data: nil)
            }
        }
    }
    
    func post(_ url: String, parameters: [String: AnyObject]? = nil, completionHandler: @escaping (_ data : AnyObject?) -> ()){
        
        Alamofire.request(.POST, url, parameters: parameters, encoding: .json, headers: Network.URLHeaders).responseJSON(options: JSONSerialization.ReadingOptions.allowFragments) { (_, _, result) -> Void in
            
            switch result {
            case .success(let data):
                completionHandler(data: data)
            case .failure(_, let error):
                print("Request failed with error: \(error)")
                completionHandler(data: nil)
            }
        }
    }
	
	func postMultipartData(_ multipartData: [String : Data], url: String, parameters: [String : AnyObject]?, completionHandler: @escaping (_ data : AnyObject?) -> ())
	{
		Alamofire.upload(
			.POST,
			url,
			headers: nil,
			multipartFormData: { (multipartFormData) -> Void in
				for (key, data) in multipartData
				{
					let filename = UUID().uuidString + ".jpg"
					multipartFormData.appendBodyPart(data: data, name: key, fileName: filename, mimeType: "image/jpeg")
				}
				
				if let parameters = parameters
				{
					for (key, parameter) in parameters
					{
						multipartFormData.appendBodyPart(data: "\(parameter)".data(using: String.Encoding.utf8, allowLossyConversion: false)!, name: key)
					}
				}
			},
			encodingMemoryThreshold: Manager.MultipartFormDataEncodingMemoryThreshold)
			{ (encodingResult) -> Void in
				switch encodingResult
				{
					case .success(let upload, _, _):
						upload.responseString { (request, response, result) -> Void in
							debugPrint(result)
						}.responseJSON { _, response, result in
							switch result
							{
								case .success(let data):
									completionHandler(data: data)
								case .failure(_, let error):
									completionHandler(data: nil)
							}
						}
					case .failure(let encodingError):
						debugPrint(encodingError)
						completionHandler(data: nil)
				}
		}
	}
	
    /**
	
     MAKE REGISTRATION
     
     - parameter username Username
     - parameter password User password
     - parameter email User Email
     - parameter userFullname Full user name
     */
    
    func signUP(_ userName: String, password: String, email: String, userFullName: String, deviceToken: String, completion: @escaping (_ data:[String:AnyObject]?) -> Void) {
        
        let url = Network.registrationURLString
        let params = ["username":userName,
            "password":password,
            "email": email,
            //"userFullname" : userFullName,
            "device_token" : deviceToken]
        
        post(url, parameters: params as [String : AnyObject]?) { (data) -> () in
            
            if (nil != data) {
                
                var returnedDictionary:[String : AnyObject] = [:]
                let registrationInfo = data as? [String : AnyObject]
                
                if let status = registrationInfo!["status"] as? String, var item = registrationInfo!["item"] as? [String:AnyObject] {
                    item["status"] = status as AnyObject?
                    returnedDictionary = item
                    
                }
                completion(returnedDictionary)
            } else {
                completion(nil)
            }
        }
    }
    
    func signUP(_ userName: String, password: String, deviceToken: String, completion: @escaping (_ data:[String:AnyObject]?) -> Void) {
        
        let url = Network.registrationURLString
        let params = ["username":userName,
                      "password":password,
                      "device_token" : deviceToken]
        
        post(url, parameters: params as [String : AnyObject]?) { (data) -> () in
            
            if (nil != data) {
                
                print("data=%@", data)
                var returnedDictionary:[String : AnyObject] = [:]
                let registrationInfo = data as? [String : AnyObject]
                
                if let status = registrationInfo!["status"] as? String, var item = registrationInfo!["item"] as? [String:AnyObject] {
                    item["status"] = status as AnyObject?
                    returnedDictionary = item
                    
                }
                completion(returnedDictionary)
            } else {
                completion(nil)
            }
        }
    }
    
    /**
     
     LOG IN
     
     - parameter username Username from registration
     - parameter password User password from registration
     */
    
    func logIn(_ userName: String, password: String, device_token: String, completion: @escaping (_ data:[String:AnyObject]?) -> Void) {
        
        let url = Network.loginURLString
        let params = ["username":userName,
            "password":password,
            "device_token":device_token]
        
        post(url, parameters: params as [String : AnyObject]?) { (data) -> () in
            
            if (nil != data) {
                var returnedDictionary: [String: AnyObject] = [:]
                let logInInfo = data as? [String : AnyObject]
                
                if let status = logInInfo!["status"] as? String, var item = logInInfo!["item"] as? [String:AnyObject] {
                    item["status"] = status as AnyObject?
                    returnedDictionary = item
                }
                completion(returnedDictionary)
            } else {
                completion(nil)
            }
        }
    }
    
    /**
     
     Get Estimates value
     
     - parameter UserID and EstimateID
     
     */
    
    func getEstimates(_ userID: String, estimateID: String, completion: @escaping (_ data:[String:AnyObject]?) -> Void) {
        let url = Network.getEstimate
        let params = ["userID":userID,
                      "estimateID":estimateID]
        
        post(url, parameters: params as [String : AnyObject]?) { (data) -> () in
            
            if (nil != data) {
//                var returnedDictionary: [String: AnyObject] = [:]
//                let logInInfo = data as? [String : AnyObject]
                print(data)
//                if let status = logInInfo!["status"] as? String, var item = logInInfo!["item"] as? [String:AnyObject] {
//                    item["status"] = status
//                    returnedDictionary = item
//                }
//                completion(data: returnedDictionary)
            } else {
                completion(nil)
            }
        }
    }
    
    /**
     
     GET MAKE
     
     - parameter year From year's make search
     */
    
    func getMakeFromYear(_ year: String, completion: @escaping (_ data:[String]?) -> Void) {
        
        let url = Network.getMakeURLString
        let params = ["year":year]
        
        post(url, parameters: params as [String : AnyObject]?) { (data) -> () in
            
            if (nil != data) {
                var returnArray: [String] = []
                
                let makes = data as! NSDictionary
                
                for items in makes["items"] as! [String] {
                    returnArray.append(items)
                }
                completion(returnArray)
            } else {
                completion(nil)
            }
        }
    }
    
    /**
     GET MODEL
     
     - parameter year From year's make search
     - parameter make Get's make from year
     */
    
    func getModel(_ year: String, make: String, completion: @escaping (_ data: [String]?) -> Void) {
        
        let url = Network.getModelURLString
        let params = ["year":year,
            "make":make]
        
        post(url, parameters: params as [String : AnyObject]?) { (data) -> () in
            
            if (nil != data) {
                var returnArray: [String] = []
                
                let models = data as! NSDictionary
                
                for items in models["items"] as! [String] {
                    returnArray.append(items)
                }
                completion(returnArray)
            } else {
                completion(nil)
            }
        }
    }
    
    /**
     GET FEATURES
     
     - parameter year From year's make search
     - parameter make Get's make from year
     - parameter model Get's model from make
     */
    
    func getFeatures(_ year: String, make: String, model: String, completion: @escaping (_ data: [String]?) -> Void) {
        
        let url = Network.getFeaturesURLString
        let params = ["year":year,
            "make":make,
            "model":model]
        
        post(url, parameters: params as [String : AnyObject]?) { (data) -> () in
            
            if (nil != data) {
                var returnArray: [String] = []
                
                let features = data as! NSDictionary
                
                for items in features["items"] as! [String] {
                    returnArray.append(items)
                }
                completion(returnArray)
            } else {
                completion(nil)
            }
        }
    }
    
    /**
     GET PRICE BY VEHICLE
     
     - parameter year From year's make search
     - parameter make Get's make from year
     - parameter model Get's model from make
     - parameter feature Get's feature from model
     */
    
    func getPriceByVehicle(_ year: String, make: String, model: String, feature: String, completion: @escaping (_ data: [String]?, _ ratingArray: NSArray) -> Void) {
        
        let url = Network.getVehiclePrice
        let params = ["year" :year,
            "make":make,
            "model":model,
            "feature":feature]
        
        post(url, parameters: params as [String : AnyObject]?) { (data) -> () in
            print(data)
            if (nil != data) {
                var returnArray: [String] = []
                let prices = data as! NSDictionary
                let ratingArray	= data!["ratings"] as! NSArray!
                for items in prices["items"] as! [String] {
                    returnArray.append(items)
                }
                completion(returnArray, ratingArray!)
            } else {
                completion(nil, [])
            }
        }
    }
    
    /**
     GET PRICE BY SIZE
     
     - parameter width Width of searched object
     - parameter ratio Ratio of searched object
     - parameter diameter Diameter of searched object
     */
    
    func getPriceBySize(_ width: String, ratio: String, diameter: String, completion: @escaping (_ data: [String]?, _ ratingArray: NSArray) -> Void) {
        
        let url = Network.getSizePrice
        let params = ["width":width,
            "ratio":ratio,
            "diameter":diameter]
        
        post(url, parameters: params as [String : AnyObject]?) { (data) -> () in
            let priceItems = data!["items"] as! NSArray!
            print(data)
            if(priceItems?.count != 0) {
                var returnArray: [String] = []
                
                let prices = data as! NSDictionary
                let ratingArray	= data!["ratings"] as! NSArray!
                for items in prices["items"] as! [String] {
                    returnArray.append(items)
                }
                completion(returnArray, ratingArray!)
            } else {
                print("failed")
                completion(nil, [])
            }
        }
    }
    
    /**
    SUBMIT EXPERIENCE
    
    - parameter userID Logged user ID
    - parameter type Can be positive or negative
    - parameter answers User answers
    - parameter name User name
    - parameter email User Email
    - parameter shop_name User shop name
    - parameter comments User comments
    */
    
    func sumbitExperience(_ userID: String, type: String, answers: String, name: String, email: String, shopName: String, comments: String, completion: @escaping (_ data: [String: AnyObject]?) -> Void) {
        
        let url = Network.submitExperience
        let params = ["userID":userID,
            "type":type,
            "answers":answers,
            "name":name,
            "email":email,
            "shop_name":shopName,
            "comments":comments]
        
        post(url, parameters: params as [String : AnyObject]?) { (data) -> () in
            if (nil != data) {
                completion(data as? [String : AnyObject])
            } else {
                completion(nil)
            }
        }
    }
	
	func submitEstimateImage(_ image: UIImage, completion: @escaping (_ success: Bool) -> ())
	{
		let url = Network.submitEstimate
		if let userID = UserDefaults.standard.object(forKey: "userID")
		{
			let params = ["userID" : userID]
			let imageData = UIImageJPEGRepresentation(image, 0.8)!
			let multipartData = ["estimateImage" : imageData]
			
			postMultipartData(multipartData, url: url, parameters: params as [String : AnyObject]?, completionHandler: { (data) -> () in
				if let data = data
				{
					if let status = data["status"] as? String, status == "OK"
					{
                        print(data)
                        //save EstimateID to local storage
                        UserDefaults.standard.setValue(data["item"], forKey: "estimateID")
                        
						completion(true)
					} else
					{
						completion(false)
					}
				} else
				{
					completion(false)
				}
			})

		} else
		{
			print("Error: User not logged in")
			completion(false)
		}
	}

	/**
     GET NEAREST LOCATIONS BY USER LOCATION
    - parameter latitude User location latitude
    - parameter longitude User location longitude
     */
    
    func getNearestLocationWithLocationLatitude(_ latitude: Double, locationLongitude longitude: Double, completion: @escaping (_ data: [[String:AnyObject]]?, _ errorMessage: String?) -> Void) {
        
        let url = Network.getNearestLocations
        let params = ["lat": latitude,
                      "lng": longitude]
        post(url, parameters: params as [String : AnyObject]?) { (data) -> () in
            
            if (nil != data) {
                var returnArray: [[String:AnyObject]] = []
                
                if let items = data!["items"] as? [[String:AnyObject]] {
                    for items in items {
                        returnArray.append(items)
                    }
                    completion(returnArray, nil)
                } else if var status = data!["status"] as? String {
                    status = status.replacingOccurrences(of: "_", with: " ")
                    completion(nil, status)
                }
            } else {
                completion(nil, "Unknown error")
            }
        }
    }
}
