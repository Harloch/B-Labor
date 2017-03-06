//
//  ChartViewController.swift
//  BareLabor
//
//  Dustin Allen
//  Copyright © 2016 BareLabor. All rights reserved.
//

import UIKit
import Foundation

enum ToggleButtons: Int {
    
    case master = 0
    case advanced = 1
    case intermediate = 2
    case begginer = 3
}

class ChartViewController: UIViewController {
    
    static let storyboardID = "ChartViewController"
    
    @IBOutlet weak var chartView: ChartView!
    @IBOutlet weak var masterButton : UIButton!
    @IBOutlet weak var advancedButton : UIButton!
    @IBOutlet weak var intermediateButton : UIButton!
    @IBOutlet weak var begginerButton : UIButton!
    @IBOutlet weak var editButton : UIButton!
    @IBOutlet weak var saveMyCarButton : UIButton!
    @IBOutlet weak var notMyCarButton : UIButton!
    
    @IBOutlet weak var lowLabel: UILabel!
    @IBOutlet weak var lowPriceLabel: UILabel!
    @IBOutlet weak var avarageLabel: UILabel!
    @IBOutlet weak var AvaragePriceLabel: UILabel!
    @IBOutlet weak var highLabel: UILabel!
    @IBOutlet weak var highPriceLabel: UILabel!
    
    var pricesForHistoryBtn: [String] = []
    var prices: [String] = []
    var ratingArray: NSArray = []
    var quantity = 1
    // Set default value for low, average, high to display default values if nothing receives.
    static var lowValue = "50"
    static var averageValue = "200"
    static var highValue = "400"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "What’s the Price?"
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        self.editButton.layer.borderColor = UIColor.white.cgColor
        self.notMyCarButton.layer.borderColor = UIColor.white.cgColor
        
        // If Pushed from NeedTireViewController
        if (self.prices.count != 0) {
            self.sortPrices(self.prices)
        }
            // If Pushed from View History Button.
        else{
            self.lowPriceLabel.text =  "$"+ChartViewController.lowValue
            self.highPriceLabel.text = "$"+ChartViewController.highValue
            self.AvaragePriceLabel.text = "$"+ChartViewController.averageValue
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let ratingArrayCount = self.ratingArray.count
        let chartViewHeight = self.chartView.frame.size.height
        let screenWidth = UIScreen.main.bounds.size.width
        let perWidth = screenWidth/CGFloat(ratingArrayCount+1)
        print("chartviewheight", chartViewHeight)
        let heightAry : NSMutableArray=[]
        let firstSize = 100
        for i in 0 ..< ratingArrayCount {
            heightAry.add(firstSize + (i * 10))
        }
        
        print(heightAry)
        var i = 0
        if (ratingArrayCount != 0) {
            for _ in ratingArray {
                let button   = UIButton(type: UIButtonType.system) as UIButton
                button.frame = CGRect(x: perWidth*CGFloat(i+1), y: chartViewHeight - CGFloat(heightAry[i] as! NSNumber), width: 9, height: CGFloat(heightAry[i] as! NSNumber))
                button.backgroundColor = UIColor.white
                button.addTarget(self, action: #selector(ChartViewController.barBtnsTapped(_:)), for: .touchUpInside)
                button.tag = ratingArrayCount-i-1
                i = i + 1
                self.chartView.addSubview(button)
            }
        }
    }
    
    func barBtnsTapped(_ sender: UIButton){
        let index = sender.tag
        let rating = self.ratingArray[index]
        
        // Initialize SCLAlertView using custom Appearance
        let alert = SCLAlertView()
        
        // Creat the subview
        let subview = UIView(frame: CGRect(x: 0,y: 0,width: 220,height: 170))
        
        let nameLabel = UILabel(frame: CGRect(x: 10, y: 10, width: 80, height: 50))
        nameLabel.textAlignment = NSTextAlignment.left
        nameLabel.textColor = UIColor.black
        nameLabel.text = "Tire Name"
        subview.addSubview(nameLabel)
        
        let nameValueLabel = UILabel(frame: CGRect(x: 90, y: 10, width: 120, height: 50))
        nameValueLabel.textAlignment = NSTextAlignment.right
        nameValueLabel.textColor = UIColor.black
        nameValueLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        nameValueLabel.numberOfLines = 100
        nameValueLabel.text = rating["t_name"] as! String!
        nameValueLabel.font = UIFont(name: (nameValueLabel.font?.fontName)!, size: 12)
        subview.addSubview(nameValueLabel)
        
        let priceLabel = UILabel(frame: CGRect(x: 10, y: 60, width: 100, height: 30))
        priceLabel.textAlignment = NSTextAlignment.left
        priceLabel.textColor = UIColor.black
        priceLabel.text = "Tire Price"
        subview.addSubview(priceLabel)
        
        let priceValueLabel = UILabel(frame: CGRect(x: 110, y: 60, width: 100, height: 30))
        priceValueLabel.textAlignment = NSTextAlignment.right
        priceValueLabel.textColor = UIColor.black
        let t_price = rating["t_price"] as! NSString!
        let quantityPrice = CGFloat(t_price.doubleValue) * CGFloat(self.quantity)
        priceValueLabel.text = "\(quantityPrice)"
        subview.addSubview(priceValueLabel)
        
        let mileageLabel = UILabel(frame: CGRect(x: 10, y: 90, width: 100, height: 30))
        mileageLabel.textAlignment = NSTextAlignment.left
        mileageLabel.textColor = UIColor.black
        mileageLabel.text = "Tire Mileage"
        subview.addSubview(mileageLabel)
        
        let mileageValueLabel = UILabel(frame: CGRect(x: 110, y: 90, width: 100, height: 30))
        mileageValueLabel.textAlignment = NSTextAlignment.right
        mileageValueLabel.textColor = UIColor.black
        mileageValueLabel.text = rating["t_mileage"] as! String!
        subview.addSubview(mileageValueLabel)
        
        let ratingLabel = UILabel(frame: CGRect(x: 10, y: 120, width: 100, height: 30))
        ratingLabel.textAlignment = NSTextAlignment.left
        ratingLabel.textColor = UIColor.black
        ratingLabel.text = "Tire Rating"
        subview.addSubview(ratingLabel)
        
        let ratingValueLabel = UILabel(frame: CGRect(x: 110, y: 120, width: 100, height: 30))
        ratingValueLabel.textAlignment = NSTextAlignment.right
        ratingValueLabel.textColor = UIColor.black
        ratingValueLabel.text = rating["t_rating"] as! String!
        subview.addSubview(ratingValueLabel)
        
        alert.customSubview = subview
        alert.showInfo("Tire Information", subTitle: "", closeButtonTitle: "Close")
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - IBAction
    
    @IBAction func didToggleButtonPressed(_ sender: UIButton){
        if let tag = ToggleButtons(rawValue: sender.tag){
            self.masterButton.backgroundColor = UIColor.clear
            self.advancedButton.backgroundColor = UIColor.clear
            self.intermediateButton.backgroundColor = UIColor.clear
            self.begginerButton.backgroundColor = UIColor.clear
            
            sender.backgroundColor = UIColor(red: 16/255.0, green: 56/255.0, blue: 125/255.0, alpha: 1)
            
            switch tag {
            case .master:
                debugPrint("Master")
            case .advanced:
                debugPrint("Advanced")
            case .intermediate:
                debugPrint("Intermediate")
            case .begginer:
                debugPrint("Begginer")
            }
        }
    }
    
    @IBAction func didPressNotMyCarButton(_ sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Private Methods
    
    fileprivate func sortPrices(_ prices: [String]) {
        
        var intPrices: [Int] = []
        
        for price in prices {
            intPrices.append((price as NSString).integerValue)
        }
        
        intPrices.sort(by: <)
        
        let lowValue = intPrices[0]
        let higherValue = intPrices.last
        
        var totalPrice = 0
        
        for price in intPrices {
            totalPrice += price
        }
        
        let avarageValue = totalPrice / intPrices.count
        
        self.lowPriceLabel.text =  "$\(lowValue)"
        self.highPriceLabel.text = "$\(higherValue!)"
        self.AvaragePriceLabel.text = "$\(avarageValue)"
        
        // Remove all prices feidl
        self.prices.removeAll()
    }
    
    @IBAction func didPressButton(_ sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
}
