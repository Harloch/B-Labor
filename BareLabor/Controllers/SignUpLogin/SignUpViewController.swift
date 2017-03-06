//
//  SignUpViewController.swift
//  BareLabor
//
//  Dustin Allen
//  Copyright © 2016 BareLabor. All rights reserved.
//

import UIKit

private enum TextfieldType: Int {
    case none = 0
    case username = 1
    case useremail = 10
    case userFullName = 2
    case password = 4
    case verifyPassword = 5
}

private enum SegmentedControlIndex: Int {
    case signUp = 0
    case login = 1
}

class SignUpViewController: BaseViewController, UITextFieldDelegate {
	
	static let storyboardID = "SignUpViewController"
	
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
//    @IBOutlet weak var userFullNameTextField: UITextField!
//    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var verifyPasswordTextField: UITextField!
    @IBOutlet weak var signUpLoginButton: UIButton!
    
    @IBOutlet weak var topContentTraling : NSLayoutConstraint!
    
    @IBOutlet weak var userNameHeight : NSLayoutConstraint!
    @IBOutlet weak var userNameIconHeight : NSLayoutConstraint!
    @IBOutlet weak var userNameSeparatorHeight : NSLayoutConstraint!
    
//    @IBOutlet weak var userFullNameHeight : NSLayoutConstraint!
//    @IBOutlet weak var userFullNameIconHeight : NSLayoutConstraint!
//    @IBOutlet weak var userFullNameSeparatorHeight : NSLayoutConstraint!
    
    @IBOutlet weak var confirmPasswordHeight : NSLayoutConstraint!
    @IBOutlet weak var confirmPasswordIconHeight : NSLayoutConstraint!
    @IBOutlet weak var confirmPasswordSeparatorHeight : NSLayoutConstraint!
    
//    @IBOutlet weak var userEmailHeight : NSLayoutConstraint!
//    @IBOutlet weak var userEmailIconHeight : NSLayoutConstraint!
//    @IBOutlet weak var userEmailSeparatorHeight : NSLayoutConstraint!
    
	@IBOutlet var activityIndicator: UIActivityIndicatorView!
	
    fileprivate var selectedTextfieldType: TextfieldType = .none
    
    var isSignUp: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Sign Up"
        
        self.signUpLoginButton.layer.borderColor = UIColor.white.cgColor
        let fixedWidthBarItem = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        fixedWidthBarItem.width = 10
        
        let keyboardToolbarItems = [fixedWidthBarItem, UIBarButtonItem(image: UIImage(named: "ToolbarGoBackward"), style: .plain, target: self, action: #selector(SignUpViewController.didPressKeyboardBackButton(_:))), fixedWidthBarItem, UIBarButtonItem(image: UIImage(named: "ToolbarGoForward"), style: .plain, target: self, action: #selector(SignUpViewController.didPressKeyboardForwardButton(_:))), UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)]
        
        let textfieldToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: Constants.Size.screenWidth.floatValue, height: 44))
        textfieldToolbar.items = keyboardToolbarItems
        
        self.emailTextField.inputAccessoryView = textfieldToolbar
        self.usernameTextField.inputAccessoryView = textfieldToolbar
//        userFullNameTextField.inputAccessoryView = textfieldToolbar
//        self.emailTextField.inputAccessoryView = textfieldToolbar
        self.passwordTextField.inputAccessoryView = textfieldToolbar
        self.verifyPasswordTextField.inputAccessoryView = textfieldToolbar
        
        
        var attributesDictionary = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName : UIFont.systemFont(ofSize: 18.0)]
        self.usernameTextField.attributedPlaceholder = NSAttributedString(string: "Create User Name", attributes: attributesDictionary)
        self.emailTextField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: attributesDictionary)
//        attributesDictionary = [NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName : UIFont.systemFontOfSize(18.0)]
//        self.userFullNameTextField.attributedPlaceholder = NSAttributedString(string: "Full Name", attributes: attributesDictionary)
//        
//        attributesDictionary = [NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName : UIFont.systemFontOfSize(18.0)]
//        self.emailTextField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: attributesDictionary)
        
        attributesDictionary = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName : UIFont.systemFont(ofSize: 18.0)]
        self.passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: attributesDictionary)
        
        attributesDictionary = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName : UIFont.systemFont(ofSize: 18.0)]
        self.verifyPasswordTextField.attributedPlaceholder = NSAttributedString(string: "Verify Password", attributes: attributesDictionary)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(SignUpViewController.onKeyboardFrameChange(_:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - IBActions
    
    @IBAction func segmentedControlValueChnged(_ sender: UISegmentedControl){
        if let index = SegmentedControlIndex(rawValue: sender.selectedSegmentIndex){
            UIView.animate(withDuration: 0.1 , animations: { () -> Void in
                switch index {
                case .signUp:
                    self.emailView.isHidden = false
//                    self.userFullNameHeight.constant = 30
//                    self.userFullNameIconHeight.constant = 24
//                    self.userFullNameSeparatorHeight.constant = 1
//                    self.userEmailHeight.constant = 30
//                    self.userEmailIconHeight.constant = 24
//                    self.userEmailSeparatorHeight.constant = 1
                    
                    self.confirmPasswordHeight.constant = 30
                    self.confirmPasswordIconHeight.constant = 24
                    self.confirmPasswordSeparatorHeight.constant = 1
                    
                    
                    let attributesDictionary = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName : UIFont.systemFont(ofSize: 18.0)]
                    self.usernameTextField.attributedPlaceholder = NSAttributedString(string: "Create User Name", attributes: attributesDictionary)
                    
                    self.isSignUp = true
                case .login:
                    
//                    self.userFullNameHeight.constant = 0
//                    self.userFullNameIconHeight.constant = 0
//                    self.userFullNameSeparatorHeight.constant = 0
//                    
//                    self.userEmailHeight.constant = 0
//                    self.userEmailIconHeight.constant = 0
//                    self.userEmailSeparatorHeight.constant = 0
                    self.emailView.isHidden = true
                    self.confirmPasswordHeight.constant = 0
                    self.confirmPasswordIconHeight.constant = 0
                    self.confirmPasswordSeparatorHeight.constant = 0
                    
                    let attributesDictionary = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName : UIFont.systemFont(ofSize: 18.0)]
                    self.usernameTextField.attributedPlaceholder = NSAttributedString(string: "User Name", attributes: attributesDictionary)
                    
                    self.isSignUp = false
                }
                self.view.layoutSubviews()
                },completion: { (finished: Bool) -> Void in
                    
                    
            });
        }
    }
    
    func didPressKeyboardBackButton(_ sender: UIBarButtonItem) {
        
        switch self.selectedTextfieldType {
//        case .UserFullName:
//            self.usernameTextField.becomeFirstResponder()
        case .username:
            self.emailTextField.becomeFirstResponder()
        case .password:
            self.usernameTextField.becomeFirstResponder()
        case .verifyPassword:
            self.passwordTextField.becomeFirstResponder()
        default:
            debugPrint("Not supported")
        }
    }
    
    func didPressKeyboardForwardButton(_ sender: UIBarButtonItem?) {
        
        switch self.selectedTextfieldType {
        case .useremail:
            self.usernameTextField.becomeFirstResponder()
        case .username:
            self.passwordTextField.becomeFirstResponder()
//        case .UserFullName:
//            self.emailTextField.becomeFirstResponder()
//        case .Email:
//            self.passwordTextField.becomeFirstResponder()
        case .password:
            self.verifyPasswordTextField.becomeFirstResponder()
        case .verifyPassword:
            self.verifyPasswordTextField.resignFirstResponder()
        default:
            debugPrint("Not supported")
        }
    }
    
    @IBAction func didPressSignUpButton(_ sender: UIButton) {
        if (isSignUp) {
            
            let userName = self.usernameTextField.text
//            let userFullName = self.userFullNameTextField.text
//            let userEmail = self.emailTextField.text
            let userPassword = self.passwordTextField.text
            let userVerifyPassword = self.verifyPasswordTextField.text
            let userEmail = self.emailTextField.text!
            
            if("" != userName && "" != userPassword && "" != userVerifyPassword && !userEmail.isEmpty) {
                if(!CommonUtils.isValidEmail(userEmail)){
                    CommonUtils.showAlert("Error", message: "Please enter correct email address.")
                    return
                }
                if (userPassword == userVerifyPassword) {
                    activityIndicator.startAnimating()
                    var deviceToken = ""
                    if(UserDefaults.standard.value(forKey: "device_token") != nil){
                        deviceToken = UserDefaults.standard.value(forKey: "device_token") as! String
                    }
                    Network.sharedInstance.signUP(userName!, password: userPassword!, email: userEmail,userFullName: "", deviceToken: deviceToken) { (data) -> Void in
                        self.activityIndicator.stopAnimating()
                        print(data)
                        if (nil != data) {
                            if ("CONFLICT" != data!["status"] as! String) {
                                
                                //fill user Defaults
                                self.setUserDefaults(data!)
                                
                            } else {
                                let alert = UIAlertController(title: "Warning", message: "User with current name existed", preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                                self.present(alert, animated: true, completion: nil)
                            }
                        } else {
                            let alert = UIAlertController(title: "Warning", message: "Connection Trouble", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        }
                    }
                } else {
                    
                    let alert = UIAlertController(title: "Warning", message: "Passwords not equal", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
                
            } else {
                
                let alert = UIAlertController(title: "Warning", message: "Please filled all fields", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        } else {
            
            let userName = self.usernameTextField.text
            let userPassword = self.passwordTextField.text
            var deviceToken = ""
            if(UserDefaults.standard.value(forKey: "device_token") != nil){
                deviceToken = UserDefaults.standard.value(forKey: "device_token") as! String
            }
            
            if("" != userName && "" != userPassword ) {
				activityIndicator.startAnimating()
                Network.sharedInstance.logIn(userName!, password: userPassword!, device_token: deviceToken, completion: { (data) -> Void in
                    self.activityIndicator.stopAnimating()
					
                    if (nil != data) {
                        if ("NOT_FOUND" != data!["status"] as? String) {
                            
                            //fill user Defaults
                            self.setUserDefaults(data!)
                            
                        } else {
                            
                            let alert = UIAlertController(title: "Warning", message: "Please check your login or password", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        }
                        
                    } else {
                        
                        let alert = UIAlertController(title: "Warning", message: "Connection Problem", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                })
            } else {
                let alert = UIAlertController(title: "Warning", message: "Please filled all fields", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    // MARK: - Private Method
    
    fileprivate func enableDisableButtonsInTextfield(_ textField: UITextField) {
        
        if let toolbar = textField.inputAccessoryView as? UIToolbar, let type = TextfieldType(rawValue: textField.tag) {
            
            if let backButton = toolbar.items?[1] {
                backButton.isEnabled = .useremail != type
            }
            if let forwardButton = toolbar.items?[4] {
                forwardButton.isEnabled = .verifyPassword != type
            }
        }
    }
    
    func setUserDefaults(_ data:[String:AnyObject]) {
        let defaults = UserDefaults.standard
        
        defaults.set(data["userID"], forKey: "userID")
        defaults.set(data["username"], forKey: "username")
        defaults.set(data["email"], forKey: "email")
        
        if let userFullName = data["userFullname"] {
            defaults.set(userFullName, forKey: "userFullname")
        }
        
        if let userLat = data["userLat"] {
            defaults.set(userLat, forKey: "userLat")
        }
        
        if let userLong = data["userLong"] {
            defaults.set(userLong, forKey: "userLong")
        }
        
        if let userAddress = data["userAddress"] {
            defaults.set(userAddress, forKey: "userAddress")
        }
        
        if let userPhone = data["userPhone"] {
            defaults.set(userPhone, forKey: "userPhone")
            
        }
        
        if let created = data["created"] {
            defaults.set(created, forKey: "created")
        }
        
        if let resetToken = data["resetToken"] {
            defaults.set(resetToken, forKey: "resetToken")
        }
        
        if let timeAgo = data["timeAgo"] {
            defaults.set(timeAgo, forKey: "timeAgo")
        }
        
        if let _ = data["userAvatar"] as? NSNull {
            
        } else {
            defaults.set(data["userAvatar"] , forKey: "userAvatar")
        }
        
        let mainViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainMenuViewController")
        self.navigationController?.pushViewController(mainViewController, animated: true)
    }
    
    // MARK: - UITextFieldDelegate Methods
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if let type = TextfieldType(rawValue: textField.tag) {
            self.selectedTextfieldType = type
        }
        self.enableDisableButtonsInTextfield(textField)
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.didPressKeyboardForwardButton(nil)
        return true
    }
    
    // MARK: - Keyboard Behavior
    
    func onKeyboardFrameChange(_ sender: Notification) {
        
        if let userInfo = sender.userInfo, let keyboardFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            
            
            UIView.animate(withDuration: (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? Double)! , animations: { () -> Void in
                if keyboardFrame.origin.y < Constants.Size.screenHeight.floatValue {//Keyboard Up
                    self.topContentTraling.constant = -93
                    
                } else {//Keyboard Down
                    self.topContentTraling.constant = 58
                    
                }
                self.view.layoutSubviews()
                },completion: { (finished: Bool) -> Void in
                    
                    
            });
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
