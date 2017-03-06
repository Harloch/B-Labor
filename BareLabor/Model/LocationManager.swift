//
//  LocationManager.swift
//  BareLabor
//
//  Dustin Allen
//  Copyright © 2016 BareLabor. All rights reserved.
//

import UIKit
import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {
    
    var manager: CLLocationManager?
    
    fileprivate var locationCompletion: ((_ error: NSError?) -> Void)?
    
    class var sharedInstance: LocationManager {
        
        struct Singleton {
            static let instance = LocationManager()
        }
        return Singleton.instance
    }
    
    // MARK: - Public Methods
    
    func startManagerWithCompletion(_ completion: ((_ error: NSError?) -> Void)?) {
        
        if nil == self.manager {
            self.manager = CLLocationManager()
            self.manager!.delegate = self
            self.manager!.desiredAccuracy = kCLLocationAccuracyBest
            self.manager!.requestWhenInUseAuthorization()
        }
        else{
            self.manager?.startUpdatingLocation()
        }
        
        if nil != completion {
            self.locationCompletion = completion
        }
    }
    
    func distanseToLocationWithLatitude(_ latitude: Double, longitude: Double) -> Double {
        
        if let myLocation = self.manager!.location {
            
            let location = CLLocation(latitude: latitude, longitude: longitude)
            let meters = myLocation.distance(from: location) as Double
            return (meters/1000) / 1.61
        }
        return 0
    }
    
    class func getFullAddressStringFromInfo(_ locationInfo: [String:AnyObject], addAddress shouldAddAddress: Bool) -> String {
        
        var fullAddress = ""
        let zipcode = locationInfo["f_zipcode"] as? String ?? ""
        if "" != zipcode {
            fullAddress = zipcode
        }
        let address = locationInfo["f_address1"] as? String ?? ""
        if "" != address {
            if "" != zipcode {
                fullAddress += (", " + address)
            } else {
                fullAddress = address
            }
        }
        
        if shouldAddAddress {
            
            var distance = ""
            if let distanceValue = locationInfo["distance"] as? Double {
                distance = "\(distanceValue)"
            } else if let distanceValue = locationInfo["distance"] as? String {
                distance = distanceValue
            }
            if "" == distance {
                
                if let f_lat = locationInfo["f_lat"] as? Double, let f_lng = locationInfo["f_lng"] as? Double {
                    let distanceValue = LocationManager.sharedInstance.distanseToLocationWithLatitude(f_lat, longitude: f_lng)
                    if 0 != distanceValue {
                        distance = "\(distanceValue)"
                    }
                }
            }
            if "" != distance {
                
                if let distanceValue = Double(distance) {
                    distance = String(format: "%.2f mi", distanceValue)
                } else {
                    let distanceString = NSString(string: distance)
                    let range = distanceString.range(of: ".")
                    if NSNotFound != range.location && distanceString.length > range.location + 2 {
                        distance = distanceString.substring(to: range.location + 2) + " mi"
                    } else {
                        distance += " mi"
                    }
                }
                if "" != fullAddress {
                    fullAddress += (" - " + distance)
                } else {
                    fullAddress = distance
                }
            }
        }
        var city = locationInfo["f_city"] as? String ?? ""
        if let state = locationInfo["f_state"] as? String {
            if "" != city {
                city += (", " + state)
            } else {
                city = state
            }
        }
        if "" != city {
            if "" != fullAddress {
                fullAddress += (" - " + city)
            } else {
                fullAddress = city
            }
        }
        
        return fullAddress
    }
    
    class func callToThePhone(_ phone: String) {
        var phone = phone
        
        phone = phone.replacingOccurrences(of: " ", with: "")
        phone = phone.replacingOccurrences(of: "-", with: "")
        phone = phone.replacingOccurrences(of: "(", with: "")
        phone = phone.replacingOccurrences(of: ")", with: "")
        if let url = URL(string: "tel://" + phone) {
            UIApplication.shared.openURL(url)
        }
    }
    
    // MARK: - CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if nil != self.locationCompletion {
            self.locationCompletion!(nil)
            self.manager?.stopUpdatingLocation()
            self.locationCompletion = nil
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        if nil != self.locationCompletion {
            self.locationCompletion!(error as NSError?)
            self.manager?.stopUpdatingLocation()
            self.locationCompletion = nil
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        var locationStatus: String?
        
        switch status {
        case CLAuthorizationStatus.restricted:
            locationStatus = "Restricted Access to location"
        case CLAuthorizationStatus.denied:
            locationStatus = "User denied access to location"
            NotificationCenter.default.post(name: Notification.Name(rawValue: Notifications.Location.StatusDenied.rawValue), object: nil, userInfo: nil)
        case CLAuthorizationStatus.notDetermined:
            locationStatus = "Status not determined"
        default:
            self.manager!.startUpdatingLocation()
            locationStatus = "Allowed to location Access"
        }
        debugPrint("Location Permision status: " + locationStatus!)
    }
}
