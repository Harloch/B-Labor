//
//  SettingsViewController.swift
//
//
//  Dustin Allen
//  Copyright © 2016 BareLabor. All rights reserved.
//

import UIKit

enum SettingsButtonTags: Int {
    case home = 4
    case viewMyHistory = 0
    case privacyPolicy = 1
    case termOfUse = 2
    case loginOut = 3
}

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var viewMyHistory : UIButton!
    @IBOutlet weak var privacyPolicy : UIButton!
    @IBOutlet weak var termsOfUse : UIButton!
    @IBOutlet weak var loginOut : UIButton!
    @IBOutlet weak var homeBtn: UIButton!
    var loginStatus:Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        self.navigationItem.title = "Settings"
        self.navigationController?.isNavigationBarHidden = true
        self.viewMyHistory.layer.borderColor = UIColor.white.cgColor
        self.privacyPolicy.layer.borderColor = UIColor.white.cgColor
        self.termsOfUse.layer.borderColor = UIColor.white.cgColor
        self.loginOut.layer.borderColor = UIColor.white.cgColor
        self.homeBtn.layer.borderColor = UIColor.white.cgColor
        
        self.setLoginButtonText() //check on login
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    //MARK: - IBAction methods
    
    @IBAction func didSettingsButtonsPressed(_ sender: UIButton){
        if let item = SettingsButtonTags(rawValue: sender.tag){
            switch item {
            case .home:
                let mainMenuViewController = self.storyboard?.instantiateViewController(withIdentifier: "MainMenuViewController") as! MainMenuViewController!
                self.navigationController?.pushViewController(mainMenuViewController!, animated: true)
                break;
            case .viewMyHistory :
                // If not logged in display alert.
                if UserDefaults.standard.object(forKey: "userID") == nil
                {
                    CommonUtils.showAlert("Sorry", message: "You have must login/register to use this feature.")
                    return
                }
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
            case .privacyPolicy :
                self.performSegue(withIdentifier: ShowSegue.Settings.TermPrivacy.rawValue, sender: SettingsButtonTags.privacyPolicy.rawValue)
            case .termOfUse :
                self.performSegue(withIdentifier: ShowSegue.Settings.TermPrivacy.rawValue, sender: SettingsButtonTags.termOfUse.rawValue)
            case .loginOut :
                debugPrint("LOGIN OUT")
                self.toggleLoginButton() // check on login
            }
        }
    }
    
    // Set Login Button Text
    func setLoginButtonText(){
        let defaults = UserDefaults.standard
        let userID = defaults.value(forKey: "userID")
        if userID != nil {
            self.loginStatus = true
            self.loginOut.setTitle("LOGOUT", for: UIControlState())
        }
        else{
            self.loginStatus = false
            self.loginOut.setTitle("LOGIN", for: UIControlState())
        }
        
    }
    // MARK: - Private methods
    
    func toggleLoginButton() {
        let defaults = UserDefaults.standard
        if self.loginStatus {
            defaults.removeObject(forKey: "userID")
            CommonUtils.showAlert("OK", message: "You have successfully logged out this app.")
            self.loginStatus = !self.loginStatus
        }
        else {
            self.loginStatus = !self.loginStatus
            if let signUpController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: SignUpViewController.storyboardID) as? SignUpViewController {
                self.navigationController?.pushViewController(signUpController, animated: false)
            }
        }
        
        let title = (self.loginStatus) ? "LOGOUT" : "LOGIN"
        self.loginOut.setTitle(title, for: UIControlState())
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ShowSegue.Settings.TermPrivacy.rawValue {
            if let senderValue = sender as? Int, let goType = SettingsButtonTags(rawValue: senderValue) {
                
                let controller = segue.destination as! TermPrivacyViewController
                controller.showContent = goType
                
                
            }
        }
    }
    
    
}
