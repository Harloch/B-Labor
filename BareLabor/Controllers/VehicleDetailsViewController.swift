//
//  VehicleDetailsViewController.swift
//  BareLabor
//
//  Dustin Allen
//  Copyright © 2016 BareLabor. All rights reserved.
//

import UIKit

private enum TextfieldType: Int {
    case none = 0
    case vinNumber = 1
    case year = 2
    case make = 3
    case model = 4
    case engineSize = 5
}

private enum InfoType: Int {
    case photo = 0
    case vinNumber = 1
    case details = 2
}

class VehicleDetailsViewController: BaseViewController, UITextFieldDelegate {
    
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var insertPhotoButton: UIButton!
    @IBOutlet weak var vinNumberTextField: UITextField!
    @IBOutlet weak var yearTextField: UITextField!
    @IBOutlet weak var makeTextField: UITextField!
    @IBOutlet weak var modelTextField: UITextField!
    @IBOutlet weak var engineSizeTextField: UITextField!
    @IBOutlet weak var submitResultButton: UIButton!
    
    
    fileprivate var photo: UIImage?
    fileprivate var selectedTextfieldFrame: CGRect = CGRect.zero
    fileprivate var selectedTextfieldType: TextfieldType = .none
    fileprivate var keyboardHeight: CGFloat = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        // Set VC title and back button
        self.navigationItem.title = "Vehicle Details"
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        self.vinNumberTextField.layer.borderWidth = 2
        self.vinNumberTextField.layer.borderColor = UIColor.white.cgColor
        var attributesDictionary = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName : UIFont.systemFont(ofSize: 18.0)]
        self.vinNumberTextField.attributedPlaceholder = NSAttributedString(string: "VIN NUMBER", attributes: attributesDictionary)
        
        self.submitResultButton.layer.borderColor = UIColor.white.cgColor
        
        let fixedWidthBarItem = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        fixedWidthBarItem.width = 10
        
        let keyboardToolbarItems = [fixedWidthBarItem, UIBarButtonItem(image: UIImage(named: "ToolbarGoBackward"), style: .plain, target: self, action: #selector(VehicleDetailsViewController.didPressKeyboardBackButton(_:))), fixedWidthBarItem, UIBarButtonItem(image: UIImage(named: "ToolbarGoForward"), style: .plain, target: self, action: #selector(VehicleDetailsViewController.didPressKeyboardForwardButton(_:))), UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)]
        let yearToolbarItems = [fixedWidthBarItem, UIBarButtonItem(image: UIImage(named: "ToolbarGoBackward"), style: .plain, target: self, action: #selector(VehicleDetailsViewController.didPressKeyboardBackButton(_:))), fixedWidthBarItem, UIBarButtonItem(image: UIImage(named: "ToolbarGoForward"), style: .plain, target: self, action: #selector(VehicleDetailsViewController.didPressKeyboardForwardButton(_:))), UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil), UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(VehicleDetailsViewController.didPressHideKeyboardButton(_:)))]
        
        let textfieldToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: Constants.Size.screenWidth.floatValue, height: 44))
        textfieldToolbar.items = keyboardToolbarItems
        
        let yearTextfieldToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: Constants.Size.screenWidth.floatValue, height: 44))
        yearTextfieldToolbar.items = yearToolbarItems
        
        self.yearTextField.inputAccessoryView = yearTextfieldToolbar
        attributesDictionary = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName : UIFont.systemFont(ofSize: 18.0)]
        self.yearTextField.attributedPlaceholder = NSAttributedString(string: "Year", attributes: attributesDictionary)
        
        self.makeTextField.inputAccessoryView = textfieldToolbar
        attributesDictionary = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName : UIFont.systemFont(ofSize: 18.0)]
        self.makeTextField.attributedPlaceholder = NSAttributedString(string: "Make", attributes: attributesDictionary)
        
        self.modelTextField.inputAccessoryView = textfieldToolbar
        attributesDictionary = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName : UIFont.systemFont(ofSize: 18.0)]
        self.modelTextField.attributedPlaceholder = NSAttributedString(string: "Model", attributes: attributesDictionary)
        
        self.engineSizeTextField.inputAccessoryView = textfieldToolbar
        attributesDictionary = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName : UIFont.systemFont(ofSize: 18.0)]
        self.engineSizeTextField.attributedPlaceholder = NSAttributedString(string: "Engine Size", attributes: attributesDictionary)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = false
        
        NotificationCenter.default.addObserver(self, selector: #selector(VehicleDetailsViewController.onKeyboardFrameChange(_:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - IBActions
    
    func didPressKeyboardBackButton(_ sender: UIBarButtonItem) {
        
        switch self.selectedTextfieldType {
        case .make:
            self.yearTextField.becomeFirstResponder()
        case .model:
            self.makeTextField.becomeFirstResponder()
        case .engineSize:
            self.modelTextField.becomeFirstResponder()
        default:
            debugPrint("Not supported")
        }
    }
    
    func didPressKeyboardForwardButton(_ sender: UIBarButtonItem) {
        
        switch self.selectedTextfieldType {
        case .year:
            self.makeTextField.becomeFirstResponder()
        case .make:
            self.modelTextField.becomeFirstResponder()
        case .model:
            self.engineSizeTextField.becomeFirstResponder()
        default:
            debugPrint("Not supported")
        }
    }
    
    func didPressHideKeyboardButton(_ sender: UIBarButtonItem) {
        
        if .year == self.selectedTextfieldType {
            self.yearTextField.resignFirstResponder()
        }
    }
    
    @IBAction func didPressSubmitButton(_ sender: UIButton) {
        
        if nil != self.photo {
            
        } else if "" != self.vinNumberTextField.text {
            
        } else {
            
            if "" == self.yearTextField.text {
                self.showNotificationAlertWithTitle("Please enter Year", message: nil, cancelButtonTitle: "OK", actionHandler: { (_) -> Void in
                    self.yearTextField.becomeFirstResponder()
                })
            } else if "" == self.makeTextField.text {
                self.showNotificationAlertWithTitle("Please enter Make", message: nil, cancelButtonTitle: "OK", actionHandler: { (_) -> Void in
                    self.makeTextField.becomeFirstResponder()
                })
            } else if "" == self.modelTextField.text {
                self.showNotificationAlertWithTitle("Please enter Model", message: nil, cancelButtonTitle: "OK", actionHandler: { (_) -> Void in
                    self.modelTextField.becomeFirstResponder()
                })
            } else if "" == self.engineSizeTextField.text {
                self.showNotificationAlertWithTitle("Please enter Engine Size", message: nil, cancelButtonTitle: "OK", actionHandler: { (_) -> Void in
                    self.engineSizeTextField.becomeFirstResponder()
                })
            } else {
                self.performSegue(withIdentifier: ShowSegue.VehicleDetails.Search.rawValue, sender: InfoType.details.rawValue)
            }
        }
    }
    
    // MARK: - Private Methods
    
    fileprivate func changeTableOffset() {
        
        let statusNavigationBarHeight: CGFloat = 64
        let textfieldYHeight = self.selectedTextfieldFrame.origin.y + self.selectedTextfieldFrame.size.height
        let nonKeyboardHeight = Constants.Size.screenHeight.floatValue - self.keyboardHeight - statusNavigationBarHeight
        if textfieldYHeight > nonKeyboardHeight {
            
            self.table.setContentOffset(CGPoint(x: 0, y: textfieldYHeight - nonKeyboardHeight - statusNavigationBarHeight + 10), animated: true)
        }
    }
    
    fileprivate func enableDisableButtonsInTextfield(_ textField: UITextField) {
        
        if let toolbar = textField.inputAccessoryView as? UIToolbar, let type = TextfieldType(rawValue: textField.tag) {
            
            if let backButton = toolbar.items?[1] {
                backButton.isEnabled = TextfieldType.year != type
            }
            if let forwardButton = toolbar.items?[3] {
                forwardButton.isEnabled = TextfieldType.engineSize != type
            }
        }
    }
    
    // MARK: - UITextFieldDelegate Methods
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if let type = TextfieldType(rawValue: textField.tag) {
            self.selectedTextfieldType = type
        }
        self.selectedTextfieldFrame = textField.frame
        self.changeTableOffset()
        self.enableDisableButtonsInTextfield(textField)
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: - Keyboard Behavior
    
    func onKeyboardFrameChange(_ sender: Notification) {
        
        if let userInfo = sender.userInfo, let keyboardFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            
            if keyboardFrame.origin.y < Constants.Size.screenHeight.floatValue {//Keyboard Up
                
                self.table.isScrollEnabled = false
                self.keyboardHeight = keyboardFrame.size.height
                self.changeTableOffset()
            } else {//Keyboard Down
                
                self.table.isScrollEnabled = true
                self.keyboardHeight = 0
                self.selectedTextfieldFrame = CGRect.zero
                self.selectedTextfieldType = .none
                self.table.setContentOffset(CGPoint(x: 0, y: -64), animated: true)
            }
        }
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == ShowSegue.VehicleDetails.Search.rawValue {
            
            if let senderValue = sender as? Int, let goType = InfoType(rawValue: senderValue) {
                
                let controller = segue.destination as! SearchViewController
                
                switch goType {
                case .details:
                    controller.inputCarInfo = CarInfo(year: self.yearTextField.text, make: self.makeTextField.text, model: self.modelTextField.text, engineSize: self.engineSizeTextField.text)
                default:
                    debugPrint("Unknown Type")
                }
            }
        }
    }
}
