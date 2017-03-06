//
//  MainMenu.swift
//  BareLabor
//
//  Dustin Allen
//  Copyright © 2016 BareLabor. All rights reserved.
//

import UIKit
import Alamofire
class MainMenuViewController: BaseViewController {

    @IBOutlet weak var iHaveAnEstimateButton: UIButton!
    @IBOutlet weak var iDoNotHaveAnEstimateButton: UIButton!
    @IBOutlet weak var iNeedATireButton: UIButton!
    @IBOutlet weak var iJustNeedAShopButton: UIButton!
    @IBOutlet weak var viewHistoryButton: UIButton!
    @IBOutlet weak var registerBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
		
        // if already registered or signed hide "Register/Login" Button
        
        if UserDefaults.standard.object(forKey: "userID") != nil
        {
            registerBtn.isHidden = true
        }
        
        self.navigationController?.isNavigationBarHidden = true
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        self.iDoNotHaveAnEstimateButton.layer.borderColor = UIColor.white.cgColor
        self.iHaveAnEstimateButton.layer.borderColor = UIColor.white.cgColor
        self.iNeedATireButton.layer.borderColor = UIColor.white.cgColor
        self.iJustNeedAShopButton.layer.borderColor = UIColor.white.cgColor
        self.viewHistoryButton.layer.borderColor = UIColor.white.cgColor
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func registerRequiredBtns(_ sender: UIButton) {
        if UserDefaults.standard.object(forKey: "userID") == nil
        {
            CommonUtils.showAlert("Sorry", message: "You have must login/register to use this feature.")
            return
        }
    
        // if "Scan My Estimate" Button is clicked
        if sender.tag == 1111 {
            let scanViewController = self.storyboard?.instantiateViewController(withIdentifier: "ScanViewController") as! ScanViewController!
            self.navigationController?.pushViewController(scanViewController!, animated: true)
        }
            
        // if "Need a Tire" Button is clicked
            
        else if sender.tag == 1112 {
            let needTireController = self.storyboard?.instantiateViewController(withIdentifier: "NeedTireViewController") as! NeedTireViewController!
            self.navigationController?.pushViewController(needTireController!, animated: true)
        }
            
        // If "View History" Button is tapped.
            
        else {
            
            // If there's no history avaiable display alerts
            if UserDefaults.standard.object(forKey: "estimateID") == nil
            {
                CommonUtils.showAlert("Sorry", message: "No History is Available.")
                return
            }
            
            let userID = UserDefaults.standard.object(forKey: "userID") as! String!
            let estimateIDNumber = UserDefaults.standard.object(forKey: "estimateID") as! NSNumber!
            let estimateID = "\(estimateIDNumber)" as String!
            
            let dict = ["userID": userID, "estimateID": estimateID]
            CommonUtils.showProgress(self.view, label: "Loading Information...")
            WebServiceObject.postRequest(WebServiceObject.getEstimatesURL, requestDict: dict) { (data, response, error) -> Void in
                
                // hide progress in main queue
                
                DispatchQueue.main.async(execute: {() -> Void in
                    
                    CommonUtils.hideProgress()
                })
                
                // received and check data
                
                if response!.statusCode == 200 {
                    let item = data!["item"] as! NSDictionary
                    if let _ = item["estimateID"] {
                        
                        let highCost = item["highCost"] as! String!
                        let averageCost = item["averageCost"] as! String!
                        let lowCost = item["lowCost"] as! String!
                        
                        if highCost == "" || averageCost == "" || lowCost == "" {
                            print("failed")
                            DispatchQueue.main.async(execute: { () -> Void in
                                CommonUtils.showAlert("Almost There!", message: "Your last submission was not confirmed yet. Please try again soon.")
                            })
                            return
                        }
                        ChartViewController.lowValue = lowCost
                        ChartViewController.averageValue = averageCost
                        ChartViewController.highValue = highCost
                        DispatchQueue.main.async(execute: { () -> Void in
                            let chartViewController = self.storyboard?.instantiateViewController(withIdentifier: "ChartViewController") as! ChartViewController!
                            self.navigationController?.pushViewController(chartViewController, animated: true)

                        })
                    }
                    
                    else{
                        CommonUtils.showAlert("Sorry", message: "No History is Available.")
                        return
                    }
                } else {
                    CommonUtils.showAlert("Sorry", message: "No History is Available.")
                    return
                }
            }

        }
    }
    
    @IBAction func registerBtnTapped(_ sender: UIButton) {
        
        if let signUpController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: SignUpViewController.storyboardID) as? SignUpViewController {
                self.navigationController?.pushViewController(signUpController, animated: false)
            }
    }
}

