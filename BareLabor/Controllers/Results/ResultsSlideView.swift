//
//  ResultsSlideView.swift
//  BareLabor
//
//  Dustin Alllen
//  Copyright © 2016 BareLabor. All rights reserved.
//

import UIKit

enum ResultsSlideItem: Int {
    
    case newSearch = 0
    case settings = 1
}

protocol ResultsSlideViewDelegate {
    
    func resultsSlideDidSelectItem(_ item: ResultsSlideItem)
}

class ResultsSlideView: UIView {
    
    @IBOutlet weak var tableView: UITableView?
    @IBOutlet weak var settingsButton: UIButton?
    @IBOutlet weak var newSearchButton: UIButton?
    @IBOutlet weak var footerTableView: UIView!
    @IBOutlet weak var deleteButton: UIButton?
    
    var delegate: ResultsSlideViewDelegate?
    var selectedSet : Set<String> = []
    var testStrings: [String] = ["Auto Spare Part Replacing Brake Pads", "Shock Absorber for Honda", "Lower Ball Joint for Toyota", "Brake Lining (FMSI: 4720 ANC CAM)", "sdf", "asdfa", "sadfasdf"]
    
    override func awakeFromNib() {
        
        if let view = Bundle.main.loadNibNamed("ResultsSlideView", owner: self, options: nil)?.first as? UIView {
            
            view.frame = self.bounds
            self.addSubview(view)
            view.backgroundColor = UIColor(red: 16/255.0, green: 56/255.0, blue: 125/255.0, alpha:0.9)
            
            self.tableView?.register(UINib(nibName: "SlideMenuTableViewCell", bundle: nil), forCellReuseIdentifier: "MenuCell")
            
            self.tableView?.tableFooterView = self.footerTableView
            
            self.settingsButton!.layer.borderColor = UIColor.white.cgColor
            self.newSearchButton!.layer.borderColor = UIColor.white.cgColor
            self.deleteButton!.layer.borderColor = UIColor.white.cgColor
        }
        
    }
    
    //MARK: - UITableViewDataSource methods
    
    func tableView( _ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell") as! SlideMenuTableViewCell
        
        cell.deselectedArrow?.isHidden = false
        cell.selectedArrow?.isHidden = true
        if (self.selectedSet.contains(self.testStrings[indexPath.row]) == true){
            cell.selectedArrow?.isHidden = false
            cell.deselectedArrow?.isHidden = true
        }
        
        cell.backgroundColor = UIColor.clear
        cell.title?.text = self.testStrings[indexPath.row]
        
        return cell
    }
    
    func tableView( _ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return self.testStrings.count;
    }
    
    //MARK: - UITableViewDelegate methods
    
    func tableView( _ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath){
        tableView.deselectRow(at: indexPath, animated: true)
        if (self.selectedSet.contains(self.testStrings[indexPath.row]) == true){
            self.selectedSet.remove(self.testStrings[indexPath.row])
        }else{
            self.selectedSet.insert(self.testStrings[indexPath.row])
        }
        tableView.reloadData()
    }
    
    //MARK: - IBAction methods
    
    @IBAction func didSlideMenuButtonsPressed(_ sender: UIButton){
        if let item = ResultsSlideItem(rawValue: sender.tag){
            self.delegate?.resultsSlideDidSelectItem(item)
        }
    }
    
    @IBAction func didDeleteButtonPressed(_ sender: UIButton){
        var testingsSet = Set(self.testStrings)
        testingsSet.subtract(self.selectedSet)
        self.testStrings = Array(testingsSet)
        self.tableView?.reloadData()
    }
    
}

