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
    
    case Master = 0
    case Advanced = 1
    case Intermediate = 2
    case Begginer = 3
}

class ChartViewController: UIViewController {
    
    static let storyboardID = "ChartViewController"
    
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
    
    // Set default value for low, average, high to display default values if nothing receives.
    static var lowValue = "50"
    static var averageValue = "200"
    static var highValue = "400"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "What’s the Price?"
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        
        self.editButton.layer.borderColor = UIColor.whiteColor().CGColor
        self.notMyCarButton.layer.borderColor = UIColor.whiteColor().CGColor
        
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - IBAction
    
    @IBAction func didToggleButtonPressed(sender: UIButton){
        if let tag = ToggleButtons(rawValue: sender.tag){
            self.masterButton.backgroundColor = UIColor.clearColor()
            self.advancedButton.backgroundColor = UIColor.clearColor()
            self.intermediateButton.backgroundColor = UIColor.clearColor()
            self.begginerButton.backgroundColor = UIColor.clearColor()
            
            sender.backgroundColor = UIColor(red: 16/255.0, green: 56/255.0, blue: 125/255.0, alpha: 1)
            
            switch tag {
            case .Master:
                debugPrint("Master")
            case .Advanced:
                debugPrint("Advanced")
            case .Intermediate:
                debugPrint("Intermediate")
            case .Begginer:
                debugPrint("Begginer")
            }
        }
    }
    
    @IBAction func didPressNotMyCarButton(sender: UIButton)
    {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    // MARK: - Private Methods
    
    private func sortPrices(prices: [String]) {
        
        var intPrices: [Int] = []
        
        for price in prices {
            intPrices.append((price as NSString).integerValue)
        }
        
        intPrices.sortInPlace(<)
        
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
    
    @IBAction func didPressButton(sender: UIButton)
    {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
}
