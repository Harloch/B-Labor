//
//  LocationMapViewController.swift
//  BareLabor
//
//  Dustin Allen
//  Copyright © 2016 BareLabor. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class LocationMapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var topViewHeight: NSLayoutConstraint!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameLabelHeight: NSLayoutConstraint!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var selfLocationButton: UIButton!
    
    var info: [String:AnyObject]!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Map"
        
        if self.map.showsUserLocation == false {
            self.selfLocationButton.isSelected = false
        } else {
            self.selfLocationButton.isSelected = true
        }
        
        self.nameLabel.text = self.info["f_location"] as? String
        self.addressLabel.text = LocationManager.getFullAddressStringFromInfo(self.info, addAddress: true)
        
        let latitude = Double(self.info["f_lat"] as! String)
        let longitude = Double(self.info["f_lng"] as! String)
        let location = CLLocation(latitude: latitude!, longitude: longitude!)
        
        var region: MKCoordinateRegion?
        if let myLocation = LocationManager.sharedInstance.manager!.location {
            let distance = myLocation.distance(from: location)
            region = MKCoordinateRegionMakeWithDistance(myLocation.coordinate, distance*2, distance*2)
        } else {
            let span = MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)
            region = MKCoordinateRegion(center: location.coordinate, span: span)
        }
        self.map.setRegion(region!, animated: true)
        self.map.delegate = self
        
        let toyAnnotation = MKPointAnnotation()
        toyAnnotation.coordinate = location.coordinate
        toyAnnotation.title = self.info["name"] as? String
        self.map.addAnnotation(toyAnnotation)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.1 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: { () -> Void in
            
                let nameLabelSize = self.nameLabel.sizeThatFits(CGSize(width: self.nameLabel.bounds.size.width, height: CGFloat.greatestFiniteMagnitude))
                let addressLabelSize = self.addressLabel.sizeThatFits(CGSize(width: self.addressLabel.bounds.size.width, height: CGFloat.greatestFiniteMagnitude))
                
                self.nameLabelHeight.constant = nameLabelSize.height
                self.topViewHeight.constant = 8 + nameLabelSize.height + 8 + addressLabelSize.height + 8
                self.view.layoutSubviews()
                self.view.updateConstraints()
        })
        
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        var locationAnnotation = mapView.dequeueReusableAnnotationView(withIdentifier: "LocationAnnotation") as? LocationAnnotation
        
        if nil == locationAnnotation {
            locationAnnotation = LocationAnnotation()
            locationAnnotation?.image = UIImage(named: "LocationPin")
            if let annotationFrame = locationAnnotation?.frame {
                locationAnnotation?.centerOffset = CGPoint(x: 0, y: -annotationFrame.size.height/2)
            }
        }
        locationAnnotation?.annotation = annotation
        
        return locationAnnotation!
    }
    
    // MARK: - IBAction methods
    
    @IBAction func didCallButtonPressed(){
        
        if let phone = self.info["f_telephone"] as? String {
            LocationManager.callToThePhone(phone);
        }
    }
    
    @IBAction func didPressSelfLocationButton(){
        if self.map.showsUserLocation == false {
            self.selfLocationButton.isSelected = true
            self.map.showsUserLocation = true
        }
        else{
            self.selfLocationButton.isSelected = false
            self.map.showsUserLocation = false
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
