//
//  NeedTireViewController.swift
//  BareLabor
//
//  Dustin Allen
//  Copyright © 2016 BareLabor. All rights reserved.
//

import UIKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func <= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l <= r
  default:
    return !(rhs < lhs)
  }
}


private enum TextfieldType: Int {
    case none = 0
    case year = 1
    case make = 2
    case model = 3
    case features = 4
    case qty1 = 5
    case size1 = 6
    case size2 = 7
    case size3 = 8
    case qty2 = 9
}

private enum PickerType: Int {
    case yearPicker = 0
    case makePicker = 1
    case modelPicker = 2
    case featuresPicker = 3
    case quantityPicker = 4
    case widthPicker = 5
    case ratiosPicker = 6
    case diametersPicker = 7
}

private enum PriceMode: Int {
    case vehiclePrice = 0
    case sizePrice = 1
    
}

class NeedTireViewController: BaseViewController, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var yearTextField: UITextField!
    @IBOutlet weak var makeTextField: UITextField!
    @IBOutlet weak var modelTextField: UITextField!
    @IBOutlet weak var featuresTextField: UITextField!
    @IBOutlet weak var qty1TextField: UITextField!
    @IBOutlet weak var byVihecleView: UIView!
    
    @IBOutlet weak var size1TextField: UITextField!
    @IBOutlet weak var size2TextField: UITextField!
    @IBOutlet weak var size3TextField: UITextField!
    @IBOutlet weak var qty2TextField: UITextField!
    @IBOutlet weak var bySizeView: UIView!
    
    
    @IBOutlet weak var choseTypeSegmentControl: UISegmentedControl!
    @IBOutlet weak var submitButtone: UIButton!
    
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    // pickers by vehicle
    fileprivate var yearPickerView: UIPickerView!
    fileprivate var makePickerView: UIPickerView!
    fileprivate var modelPickerView: UIPickerView!
    fileprivate var featuresPickerView: UIPickerView!
    fileprivate var quantityPickerView: UIPickerView!
    
    fileprivate var years: [String] = []
    fileprivate var makes: [String] = []
    fileprivate var models: [String] = []
    fileprivate var features: [String] = []
    
    // pickers by size
    fileprivate var widthPickerView: UIPickerView!
    fileprivate var ratiosPickerView: UIPickerView!
    fileprivate var diamteresPickerView: UIPickerView!
    
    fileprivate var widths: [String] = []
    fileprivate var ratios: [String] = []
    fileprivate var diameters: [String] = []
    fileprivate var quantities: [String] = []
    
    fileprivate var pickerType:PickerType = .yearPicker
    
    fileprivate var quantity: String?
    fileprivate var sizePrices: [String] = []
    fileprivate var vehiclePrices: [String] = []
    
    fileprivate var selectedTextfieldFrame: CGRect = CGRect.zero
    fileprivate var selectedTextfieldType: TextfieldType = .none
    fileprivate var keyboardHeight: CGFloat = 0
    
    fileprivate var priceMode: PriceMode = .vehiclePrice {
        didSet {
            if .vehiclePrice == self.priceMode {
                self.byVihecleView.isHidden = false
                self.bySizeView.isHidden = true
            } else {
                self.bySizeView.isHidden = false
                self.byVihecleView.isHidden = true
            }
        }
    }
    fileprivate var ratingArray: NSArray = []
    fileprivate var vehicleQuantity = 1
    fileprivate var sizeQuantity = 1
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Navigation bar
        self.submitButtone.layer.borderColor = UIColor.white.cgColor
        
        self.navigationItem.title = "Need A Tire"
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        // tableView
        self.table.tableFooterView = UIView(frame: CGRect.zero)
        
        // setup textfields and pickers
        self.setUpTextFields()
        
        //get years
        self.years = self.getYears()
        
        //get widths
        self.widths = self.getWidths()
        
        //get ratio
        self.ratios = self.getHeights()
        
        //get diameters
        self.diameters = self.getRim()
        
        //get quantities
        self.quantities = self.getQuantity()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = false
        
        NotificationCenter.default.addObserver(self, selector: #selector(NeedTireViewController.onKeyboardFrameChange(_:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - IBActions
    
    func didPressHideKeyboardButton(_ sender: UIBarButtonItem) {
        
        switch self.selectedTextfieldType {
        case .year:
            self.yearTextField.resignFirstResponder()
        case .qty1:
            self.qty1TextField.resignFirstResponder()
        case .size1:
            self.size1TextField.resignFirstResponder()
        case .size2:
            self.size2TextField.resignFirstResponder()
        case .size3:
            self.size3TextField.resignFirstResponder()
        case .qty2:
            self.qty2TextField.resignFirstResponder()
        default:
            debugPrint("Unsupported Type")
        }
    }
    
    @IBAction func didPressSubmitButton(_ sender: UIButton) {
        
        self.sizePrices = []
        self.vehiclePrices = []
        
        let year = self.yearTextField.text
        let make = self.makeTextField.text
        let model = self.modelTextField.text
        let feature = self.featuresTextField.text
        let quantityVehicle = self.qty1TextField.text
        
        let width = self.size1TextField.text
        let ratio = self.size2TextField.text
        let diameter = self.size3TextField.text
        let sizeQuantity = self.qty2TextField.text
        ratingArray = []
        switch(self.priceMode) {
            
        case .vehiclePrice:
            
            if ("" != year && "" != make && "" != model && "" != feature && "" != quantityVehicle) {
                CommonUtils.showProgress(self.view, label: "Reading data...")
                Network.sharedInstance.getPriceByVehicle(year!, make: make!, model: model!, feature: feature!, completion: { (data, ratingArray) -> Void in
                    self.submitButtone.isEnabled = true;
                    DispatchQueue.main.async(execute: {
                      CommonUtils.hideProgress()
                    })
                    if (nil != data) {                        
                        for price in data! {
                            let newPrice = Int(Double(price)! * Double(quantityVehicle!)!)
                            self.vehiclePrices.append(String(newPrice))
                        }
                        self.ratingArray = ratingArray
                        self.vehicleQuantity = Int(quantityVehicle!)!
                        self.performSegue(withIdentifier: ShowSegue.NeedTire.Chart.rawValue, sender: self)
                        
                    } else {
                        self.showAlertWithMessage("Please correct searched fields")
                    }
                })
            } else {
                self.showAlertWithMessage("Please fill searched fields")
            }
            break;
            
        case .sizePrice:
            
            if ("" != width && "" != ratio && "" != diameter && "" != sizeQuantity) {
                CommonUtils.showProgress(self.view, label: "Reading data...")
                Network.sharedInstance.getPriceBySize(width!, ratio: ratio!, diameter: diameter!, completion: { (data, ratingArray) -> Void in
                    DispatchQueue.main.async(execute: {
                        CommonUtils.hideProgress()
                    })
                    self.submitButtone.isEnabled = true;
                    if (nil != data) {
                        for price in data! {
                            let newPrice = Double(price)! * Double(sizeQuantity!)!
                            self.sizePrices.append(String(newPrice))
                        }
                        self.ratingArray = ratingArray
                        self.sizeQuantity = Int(sizeQuantity!)!
                        self.performSegue(withIdentifier: ShowSegue.NeedTire.Chart.rawValue, sender: self)
                        
                    } else {
                        self.showAlertWithMessage("There's no data for searched fields in database. Please correct searched fields.")
                    }
                })
            } else {
                self.showAlertWithMessage("Please fill searched fields")
            }
            break;
        }
    }
    
    @IBAction func didPressSaveMyCarButton(_ sender: UIButton) {
        self.performSegue(withIdentifier: ShowSegue.NeedTire.SignUp.rawValue, sender: nil)
    }
    
    func didPressYearTextFieldDone(_ sender: UIBarButtonItem) {
        self.yearTextField.resignFirstResponder()
    }
    
    func didPressMakePickerViewDone(_ sender: UIBarButtonItem) {
        self.makeTextField.resignFirstResponder()
    }
    
    func didPressModelPickerViewDone(_ sender: UIBarButtonItem) {
        self.modelTextField.resignFirstResponder()
    }
    
    func didPressFeaturesPickerViewDone(_ sender: UIBarButtonItem) {
        self.featuresTextField.resignFirstResponder()
    }
    
    func didPressQuantity1PickerViewDone(_ sender: UIBarButtonItem) {
        self.qty1TextField.resignFirstResponder()
    }
    
    func didPressQuantity2PickerViewDone(_ sender: UIBarButtonItem) {
        self.qty2TextField.resignFirstResponder()
    }
    
    @IBAction func segmentDidChange(_ sender: AnyObject) {
        switch(sender.selectedSegmentIndex) {
        case PriceMode.vehiclePrice.rawValue:
            self.priceMode = .vehiclePrice
        case PriceMode.sizePrice.rawValue:
            self.priceMode = .sizePrice
        default:
            break
        }
    }
    
    // MARK: - Private Method
    
    fileprivate func changeTableOffset() {
        
        let statusNavigationBarHeight: CGFloat = 64
        let textfieldYHeight = self.selectedTextfieldFrame.origin.y + self.selectedTextfieldFrame.size.height
        let nonKeyboardHeight = Constants.Size.screenHeight.floatValue - self.keyboardHeight - statusNavigationBarHeight
        if textfieldYHeight > nonKeyboardHeight {
            
            self.table.setContentOffset(CGPoint(x: 0, y: textfieldYHeight - nonKeyboardHeight - statusNavigationBarHeight + 10), animated: true)
        }
    }
    
    fileprivate func setUpTextFields() {
        
        // keyBoard
        let textfieldToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: Constants.Size.screenWidth.floatValue, height: 44))
        textfieldToolbar.items = [UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil), UIBarButtonItem(barButtonSystemItem: .done, target: self, action: "didPressHideKeyboardButton:")]
        
        // year textField
        
        var attributesDictionary = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName : UIFont.systemFont(ofSize: 18.0)]
        self.yearTextField.attributedPlaceholder = NSAttributedString(string: "Year", attributes: attributesDictionary)
        self.yearPickerView = UIPickerView()
        self.yearPickerView.showsSelectionIndicator = true
        self.yearPickerView.delegate = self
        self.yearPickerView.dataSource = self
        self.yearPickerView.tag = PickerType.yearPicker.rawValue
        self.yearTextField.inputView = self.yearPickerView
        
        let yearTextFieldToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 44))
        yearTextFieldToolbar.items = [UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil), UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(NeedTireViewController.didPressYearTextFieldDone(_:)))]
        self.yearTextField.inputAccessoryView = yearTextFieldToolbar
        
        // make textField
        attributesDictionary = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName : UIFont.systemFont(ofSize: 18.0)]
        self.makeTextField.attributedPlaceholder = NSAttributedString(string: "Make", attributes: attributesDictionary)
        self.makePickerView = UIPickerView()
        self.makePickerView.showsSelectionIndicator = true
        self.makePickerView.delegate = self
        self.makePickerView.dataSource = self
        self.makePickerView.tag = PickerType.makePicker.rawValue
        self.makeTextField.inputView = self.makePickerView
        
        let makeTextFieldToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 44))
        makeTextFieldToolbar.items = [UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil), UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(NeedTireViewController.didPressMakePickerViewDone(_:)))]
        self.makeTextField.inputAccessoryView = makeTextFieldToolbar
        
        // model textField
        attributesDictionary = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName : UIFont.systemFont(ofSize: 18.0)]
        self.modelTextField.attributedPlaceholder = NSAttributedString(string: "Model", attributes: attributesDictionary)
        self.modelPickerView = UIPickerView()
        self.modelPickerView.showsSelectionIndicator = true
        self.modelPickerView.delegate = self
        self.modelPickerView.dataSource = self
        self.modelPickerView.tag = PickerType.modelPicker.rawValue
        self.modelTextField.inputView = self.modelPickerView
        
        let modelTextFieldToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 44))
        modelTextFieldToolbar.items = [UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil), UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(NeedTireViewController.didPressModelPickerViewDone(_:)))]
        self.modelTextField.inputAccessoryView = modelTextFieldToolbar
        
        // featuresTextField
        attributesDictionary = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName : UIFont.systemFont(ofSize: 18.0)]
        self.featuresTextField.attributedPlaceholder = NSAttributedString(string: "Features", attributes: attributesDictionary)
        self.featuresPickerView = UIPickerView()
        self.featuresPickerView.showsSelectionIndicator = true
        self.featuresPickerView.delegate = self
        self.featuresPickerView.dataSource = self
        self.featuresPickerView.tag = PickerType.featuresPicker.rawValue
        self.featuresTextField.inputView = self.featuresPickerView
        
        let featuresTextFieldToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 44))
        featuresTextFieldToolbar.items = [UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil), UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(NeedTireViewController.didPressFeaturesPickerViewDone(_:)))]
        self.featuresTextField.inputAccessoryView = featuresTextFieldToolbar
        
        // quantity TextFields
        attributesDictionary = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName : UIFont.systemFont(ofSize: 18.0)]
        self.quantityPickerView = UIPickerView()
        self.quantityPickerView.showsSelectionIndicator = true
        self.quantityPickerView.delegate = self
        self.quantityPickerView.dataSource = self
        self.quantityPickerView.tag = PickerType.quantityPicker.rawValue
        self.qty1TextField.inputView = self.quantityPickerView
        self.qty2TextField.inputView = self.quantityPickerView
        
        let quantity1Toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 44))
        quantity1Toolbar.items = [UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil), UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(NeedTireViewController.didPressQuantity1PickerViewDone(_:)))]
        self.qty1TextField.inputAccessoryView = quantity1Toolbar
        
        let quantity2Toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 44))
        quantity1Toolbar.items = [UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil), UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(NeedTireViewController.didPressQuantity2PickerViewDone(_:)))]
        self.qty2TextField.inputAccessoryView = quantity2Toolbar
        
        // width textField
        attributesDictionary = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName : UIFont.systemFont(ofSize: 14.0)]
        self.size1TextField.attributedPlaceholder = NSAttributedString(string: "Tire Width", attributes: attributesDictionary)
        
        self.widthPickerView = UIPickerView()
        self.widthPickerView.showsSelectionIndicator = true
        self.widthPickerView.delegate = self
        self.widthPickerView.dataSource = self
        self.widthPickerView.tag = PickerType.widthPicker.rawValue
        self.size1TextField.inputView = self.widthPickerView
        
        // ratio textField
        attributesDictionary = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName : UIFont.systemFont(ofSize: 14.0)]
        self.size2TextField.attributedPlaceholder = NSAttributedString(string: "Aspect Ratio", attributes: attributesDictionary)
        
        self.ratiosPickerView = UIPickerView()
        self.ratiosPickerView.showsSelectionIndicator = true
        self.ratiosPickerView.delegate = self
        self.ratiosPickerView.dataSource = self
        self.ratiosPickerView.tag = PickerType.ratiosPicker.rawValue
        self.size2TextField.inputView = self.ratiosPickerView
        
        // diameter textField
        attributesDictionary = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName : UIFont.systemFont(ofSize: 14.0)]
        self.size3TextField.attributedPlaceholder = NSAttributedString(string: "Rim Diameter", attributes: attributesDictionary)
        
        self.diamteresPickerView = UIPickerView()
        self.diamteresPickerView.showsSelectionIndicator = true
        self.diamteresPickerView.delegate = self
        self.diamteresPickerView.dataSource = self
        self.diamteresPickerView.tag = PickerType.diametersPicker.rawValue
        self.size3TextField.inputView = self.diamteresPickerView
        
        
        self.qty1TextField.inputAccessoryView = textfieldToolbar
        self.size1TextField.inputAccessoryView = textfieldToolbar
        self.size2TextField.inputAccessoryView = textfieldToolbar
        self.size3TextField.inputAccessoryView = textfieldToolbar
        self.qty2TextField.inputAccessoryView = textfieldToolbar
        
    }
    
    fileprivate func getYears() -> [String] {
        var years = [String]()
        let todayDate = Date()
        let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        let currentYear = (calendar as NSCalendar).components(.year, from: todayDate)
        
        for var i = 1953; i <= currentYear.year; i += 1 {
            years.append(String(i))
        }
        years.sort(by: >)
        
        self.yearTextField.text = "2016"
        
        // get default makes
        
        if "" != self.yearTextField.text &&  4 <= self.yearTextField.text?.characters.count {
            
            if 0 != makes.count {
                self.makes.removeAll()
            }
            
            Network.sharedInstance.getMakeFromYear(self.yearTextField.text!) { (data) -> Void in
                
                if (nil != data) {
                    debugPrint("\(data)")
                    self.makes = data!
                    self.yearTextField.resignFirstResponder()
                } else {
                    self.showAlertWithMessage("Please correct searched fields")
                }
            }
        }
        
        return years
    }
    
    fileprivate func getWidths() -> [String] {
        
        var widths = [String]()
        
        var counter = 10
        
        for var i = 105; i <= 395; i = i + counter {
            
            if 355 == i {
                counter = 20
            }
            
            widths.append(String(i))
        }
        
        for var i = 24; i <= 42; i += 1 {
            widths.append(String(i) + "X")
        }
        
        widths.append(String(7))
        widths.append(String(7.5))
        widths.append(String(8))
        widths.append(String(8.75))
        widths.append(String(9.5))
        
        self.size1TextField.text = widths[0] // set default width
        return widths
    }
    
    fileprivate func getHeights() -> [String] {
        var heights = [String]()
        
        let counter = 5
        
        for var i = 20; i <= 95; i = i + counter {
            heights.append(String(i))
        }
        
        let doubleCounter = 0.5
        
        for var i = 7.5; i <= 18.5; i = i + doubleCounter {
            heights.append(String(i))
        }
        heights.append("0")
        
        self.size2TextField.text = heights[0] // set default ratio
        
        return heights
    }
    
    fileprivate func getRim() -> [String] {
        var rims = [String]()
        
        var counter = 2
        
        for var i = 10; i <= 16; i = i + counter {
            
            rims.append(String(i))
            if 12 == i {
                counter = 1
            }
            
        }
        
        for var i = 16.5; i  <= 20; i = i + 0.5 {
            rims.append(String(i))
        }
        
        counter = 1
        
        for var i = 21; i <= 30; i = i + counter {
            
            rims.append(String(i))
            if 26 == i {
                counter = 2
            }
        }
        
        rims.sort(by: <)
        
        self.size3TextField.text = rims[0] // set default diameter
        
        return rims
    }
    
    fileprivate func getQuantity() -> [String] {
        var quantities = [String]()
        
        for var i = 1; i <= 12; i += 1 {
            quantities.append(String(i))
        }
        
        // set defaults quantities
        self.qty1TextField.text = quantities[0]
        self.qty2TextField.text = quantities[0]
        
        return quantities
    }
    
    fileprivate func showAlertWithMessage(_ message: String) {
        
        let alert = UIAlertController(title: "Warning", message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (alertController) -> Void in
            alert.dismiss(animated: true, completion: nil)
        }))
        defer {
            DispatchQueue.main.async { () -> Void in
                self.present(alert, animated: true, completion: { () -> Void in
                    
                })
            }
        }
    }
    
    fileprivate func shouldCleanTextFields(forTag tag: Int) {
        
        switch(tag) {
        case TextfieldType.year.rawValue:
            self.makeTextField.text = ""
            self.modelTextField.text = ""
            self.featuresTextField.text = ""
            
        case TextfieldType.make.rawValue:
            self.modelTextField.text = ""
            self.featuresTextField.text = ""
            
        case TextfieldType.model.rawValue:
            self.featuresTextField.text = ""
            
        default:
            break
        }
    }
    
    //MARK: - UIPickerViewDataSource and UIPickerViewDelegate Methods
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        var returnValue = 0
        
        switch(pickerView.tag) {
            
        case PickerType.yearPicker.rawValue:
            returnValue = self.years.count
        case PickerType.makePicker.rawValue:
            returnValue = self.makes.count
        case PickerType.modelPicker.rawValue:
            returnValue = self.models.count
        case PickerType.featuresPicker.rawValue:
            returnValue = self.features.count
        case PickerType.quantityPicker.rawValue:
            returnValue = self.quantities.count
        case PickerType.widthPicker.rawValue:
            returnValue = self.widths.count
        case PickerType.ratiosPicker.rawValue:
            returnValue = self.ratios.count
        case PickerType.diametersPicker.rawValue:
            returnValue = self.diameters.count
        default:
            returnValue = 0
        }
        
        return returnValue
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        var returnValue: String = ""
        
        switch(pickerView.tag) {
            
        case PickerType.yearPicker.rawValue:
            returnValue = self.years[row]
        case PickerType.makePicker.rawValue:
            if 0 != self.makes.count {
                returnValue = self.makes[row]
            }
            
        case PickerType.modelPicker.rawValue:
            if 0 != self.models.count {
                returnValue = self.models[row]
            }
            
        case PickerType.featuresPicker.rawValue:
            if 0 != self.features.count {
                returnValue = self.features[row]
            }
        case PickerType.quantityPicker.rawValue:
            returnValue = self.quantities[row]
        case PickerType.widthPicker.rawValue:
            returnValue = self.widths[row]
        case PickerType.ratiosPicker.rawValue:
            returnValue = self.ratios[row]
        case PickerType.diametersPicker.rawValue:
            returnValue = self.diameters[row]
        default:
            returnValue = ""
        }
        
        return returnValue
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch(pickerView.tag) {
            
        case PickerType.yearPicker.rawValue:
            self.yearTextField.text = self.years[row]
        case PickerType.makePicker.rawValue:
            if 0 != self.makes.count {
                self.makeTextField.text = self.makes[row]
            }
        case PickerType.modelPicker.rawValue:
            
            if 0 != self.models.count {
                self.modelTextField.text = self.models[row]
            }
            
        case PickerType.featuresPicker.rawValue:
            
            if 0 != self.features.count {
                self.featuresTextField.text = self.features[row]
            }
            
        case PickerType.quantityPicker.rawValue:
            
            if .qty1 == self.selectedTextfieldType {
                self.qty1TextField.text = self.quantities[row]
            } else {
                self.qty2TextField.text = self.quantities[row]
            }
            
        case PickerType.widthPicker.rawValue:
            self.size1TextField.text = self.widths[row]
        case PickerType.ratiosPicker.rawValue:
            self.size2TextField.text = self.ratios[row]
        case PickerType.diametersPicker.rawValue:
            self.size3TextField.text = self.diameters[row]
        default:
            break
        }
    }
    
    // MARK: - UITextFieldDelegate Methods
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        var fillChecker: Bool = true
        
        switch(textField.tag) {
            
        case TextfieldType.year.rawValue:
            debugPrint("year")
        case TextfieldType.make.rawValue:
            
            if "" == self.yearTextField.text {
                self.showAlertWithMessage("Please fill the year field")
                fillChecker = false
            }
            
        case TextfieldType.model.rawValue:
            
            if "" == self.yearTextField.text && "" == self.makeTextField.text {
                self.showAlertWithMessage("Please fill the year and make fields")
                fillChecker = false
                
            } else if "" == self.yearTextField.text {
                self.showAlertWithMessage("Please fill the year field")
                fillChecker = false
            } else if "" == self.makeTextField.text {
                self.showAlertWithMessage("Please fill the make field")
                fillChecker = false
            }
            
        case TextfieldType.features.rawValue:
            
            if "" == self.yearTextField.text && "" == self.makeTextField.text && "" == self.modelTextField.text {
                self.showAlertWithMessage("Please fill the and year, make and model fields")
                fillChecker = false
                
            } else if "" == self.yearTextField.text {
                self.showAlertWithMessage("Please fill the year field")
                fillChecker = false
            } else if "" == self.makeTextField.text {
                self.showAlertWithMessage("Please fill the make field")
                fillChecker = false
            } else if "" == self.modelTextField.text {
                self.showAlertWithMessage("Please fill the model field")
                fillChecker = false
            }
            
        case TextfieldType.qty1.rawValue:
            break
        case TextfieldType.size1.rawValue:
            break
        case TextfieldType.size2.rawValue:
            break
        case TextfieldType.size3.rawValue:
            break
        case TextfieldType.qty2.rawValue:
            break
        default:
            break
        }
        
        // keyboard
        if let type = TextfieldType(rawValue: textField.tag) {
            self.selectedTextfieldType = type
        }
        
        var frame = textField.frame
        
        if .year == self.selectedTextfieldType || .make == self.selectedTextfieldType || .model == self.selectedTextfieldType || .features == self.selectedTextfieldType || .qty1 == self.selectedTextfieldType{
            frame.origin.y += (self.byVihecleView.frame.origin.y + (.qty1 != self.selectedTextfieldType ? self.qty1TextField.frame.size.height : 0) + (.features != self.selectedTextfieldType ? self.featuresTextField.frame.size.height : 0))
        }
        
        if .size1 == self.selectedTextfieldType || .size2 == self.selectedTextfieldType || .size3 == self.selectedTextfieldType || .qty2 == self.selectedTextfieldType{
            frame.origin.y += (self.bySizeView.frame.origin.y + (.qty2 != self.selectedTextfieldType ? self.qty2TextField.frame.size.height : 0))
        }
        
        self.selectedTextfieldFrame = frame
        self.changeTableOffset()
        
        return fillChecker
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        switch(textField.tag) {
            
        case TextfieldType.year.rawValue:
            
            let year = self.yearTextField.text
            
            if "" != year &&  4 <= year?.characters.count {
                
                if 0 != makes.count {
                    self.makes.removeAll()
                }
                
                Network.sharedInstance.getMakeFromYear(self.yearTextField.text!) { (data) -> Void in
                    
                    if (nil != data) {
                        debugPrint("\(data)")
                        self.makes = data!
                        self.yearTextField.resignFirstResponder()
                        self.makePickerView.reloadAllComponents()
                        self.shouldCleanTextFields(forTag: textField.tag) // clean textFields
                    } else {
                        self.showAlertWithMessage("Please correct searched fields")
                    }
                }
            } else {
            }
            
        case TextfieldType.make.rawValue:
            
            let year = self.yearTextField.text
            let make = self.makeTextField.text
            
            if "" != make && "" != year {
                
                if 0 != models.count {
                    self.models.removeAll()
                }
                
                Network.sharedInstance.getModel(year!, make: make!, completion: { (data) -> Void in
                    
                    if (nil != data) {
                        debugPrint("\(data)")
                        self.models = data!
                        self.makeTextField.resignFirstResponder()
                        self.modelPickerView.reloadAllComponents()
                        self.shouldCleanTextFields(forTag: textField.tag) // clean textFields
                    } else {
                        self.showAlertWithMessage("Please correct searched fields")
                    }
                })
            } else {
            }
            
        case TextfieldType.model.rawValue:
            
            self.modelTextField.isUserInteractionEnabled = true
            
            let year = self.yearTextField.text
            let make = self.makeTextField.text
            let model = self.modelTextField.text
            
            if "" != year && "" != make && "" != model {
                
                if 0 != features.count {
                    self.features.removeAll()
                }
                
                Network.sharedInstance.getFeatures(year!, make: make!, model: model!, completion: { (data) -> Void in
                    
                    if (nil != data) {
                        debugPrint("\(data)")
                        self.features = data!
                        self.modelTextField.resignFirstResponder()
                        self.featuresPickerView.reloadAllComponents()
                        self.shouldCleanTextFields(forTag: textField.tag) // clean textFields
                    } else {
                        self.showAlertWithMessage("Please correct searched fields")
                    }
                })
            } else {
            }
            
        default:
            break
            
        }
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
        if segue.identifier == ShowSegue.NeedTire.Chart.rawValue {
            
            if let controller = segue.destination as? ChartViewController {
                debugPrint("show chart controller")
                
                switch(self.priceMode) {
                case .vehiclePrice:
                    controller.prices = self.vehiclePrices
                    controller.quantity = self.vehicleQuantity
                    controller.ratingArray = self.ratingArray
                    break
                case .sizePrice:
                    controller.prices = self.sizePrices
                    controller.quantity = self.sizeQuantity
                    controller.ratingArray = self.ratingArray
                    break
                }
            }
        }
    }
}
