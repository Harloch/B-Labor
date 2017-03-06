//
//  ShopListViewController.swift
//  BareLabor
//
//  Dustin Allen
//  Copyright © 2016 BareLabor. All rights reserved.
//

import UIKit
import CoreLocation
import MBProgressHUD

enum TappedButton: Int {
    case call = 0
    case location = 1
}

class ShopListViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate,  CallOrLocationButtonDelegate{
    
    @IBOutlet weak var table: UITableView!
    
    var inputCarInfo: [String:String]?
    
    fileprivate var shopList : [[String:AnyObject]] = []

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Locations"
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        self.table.tableFooterView = UIView(frame: CGRect.zero)
        
        let applicationDelegate = UIApplication.shared.delegate as! AppDelegate
        MBProgressHUD.showAdded(to: applicationDelegate.window, animated: true)
        
        LocationManager.sharedInstance.startManagerWithCompletion({ (error) -> Void in
            
            DispatchQueue.main.async(execute: { () -> Void in
                
                if nil != error {
                    MBProgressHUD.hideAllHUDs(for: applicationDelegate.window, animated: true)
                    self.showNotificationAlertWithTitle("Warning", message: error?.localizedDescription, cancelButtonTitle: "OK", actionHandler: nil)
                } else {
                    
                    if let location = LocationManager.sharedInstance.manager?.location {
                        Network.sharedInstance.getNearestLocationWithLocationLatitude(location.coordinate.latitude, locationLongitude: location.coordinate.longitude, completion: { (data, errorMessage) -> Void in
                            
                            MBProgressHUD.hideAllHUDs(for: applicationDelegate.window, animated: true)
                            if nil != data {
                                self.shopList = data!
                                self.table.reloadData()
                            } else {
                                self.showNotificationAlertWithTitle("Warning", message: errorMessage, cancelButtonTitle: "OK", actionHandler: nil)
                            }
                        })
                    } else {
                        MBProgressHUD.hideAllHUDs(for: applicationDelegate.window, animated: true)
                        self.showNotificationAlertWithTitle("Warning", message: "Cannot retrieve your location", cancelButtonTitle: "OK", actionHandler: nil)
                    }
                }
            })
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.shopList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let dictionary = self.shopList[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell") as! LocationCell
        cell.shopeNameLabel.text = dictionary["f_location"] as? String
        cell.addressNameLabel.text = LocationManager.getFullAddressStringFromInfo(dictionary, addAddress: true)
        cell.delegate = self
        cell.indexPath = indexPath
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView( _ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?{
        
        if nil != self.inputCarInfo {
            let viewFrame = CGRect(x: 0.0, y: 0.0, width: Constants.Size.screenWidth.rawValue, height: 110.0)
            let header = CarInfoView.init(frame: viewFrame)
            header.setYear("1918", make: "Mercedes-Bens", model: "T1000", engineSize: "8.5L Diesel")
            return header
        }
        return nil
    }
    
    func tableView( _ tableView: UITableView,heightForHeaderInSection section: Int) -> CGFloat{
        return (nil == self.inputCarInfo ? 0.0 : 110.0)
    }
    
    // MARK: - Delegate methods

    func callOrLocationButtonPressed(_ item: IndexPath, sentderTag: Int) {
        
        if let buttonTapped = TappedButton(rawValue: sentderTag){
            
            let dictionary = self.shopList[item.row]
            switch buttonTapped {
            case .call:
                
                if let phone = dictionary["f_telephone"] as? String {
                    LocationManager.callToThePhone(phone);
                }
            case .location:
                self.performSegue(withIdentifier: ShowSegue.ShopList.LocationMap.rawValue, sender:dictionary)
            }
        }
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == ShowSegue.ShopList.LocationMap.rawValue {
            if let info = sender as? [String:AnyObject] {
                let controller = segue.destination as! LocationMapViewController
                controller.info = info
                controller.navigationItem.title = info["name"] as? String
                
            }
        }
    }
}
