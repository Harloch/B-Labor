//
//  ResultsViewController.swift
//  BareLabor
//
//  Dustin Allen
//  Copyright © 2016 BareLabor. All rights reserved.
//

import UIKit

class ResultsViewController: BaseViewController , ResultsSlideViewDelegate {

    @IBOutlet weak var sideMenuTralingConstraint : NSLayoutConstraint!
    @IBOutlet weak var slideMenu : ResultsSlideView!
    @IBOutlet weak var collectionView : UICollectionView!
    @IBOutlet weak var myCar : UIButton!
    @IBOutlet weak var notMyCar : UIButton!
    @IBOutlet weak var whatThePriceButton : UIButton!
    @IBOutlet weak var findNearestLoctionButton : UIButton!
    @IBOutlet weak var tellUsYourExpirienceButton : UIButton!
    @IBOutlet weak var addAnotherService : UIButton!
    @IBOutlet weak var logoImage : UIImageView!
    
    var buttons : [String] = ["ALL", "BRAKES", "STRUTS", "LIGHTS","ALL", "BRAKES", "STRUTS", "LIGHTS"]
    var offset : CGFloat = 0
    var selectedButton : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UIScreen.main.bounds.size.height == 480.0{
            self.logoImage.image = nil
        }
        
        
        self.collectionView.layer.borderColor = UIColor.white.cgColor
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        let sideButton = UIButton(frame:CGRect(x: 0.0, y: 0.0, width: 19.0, height: 17.0))
        sideButton.setBackgroundImage(UIImage(named: "SideMenuImage"), for: UIControlState())
        sideButton.addTarget(self, action: #selector(ResultsViewController.showSideMenu(_:)), for: .touchUpInside)
       
        self.notMyCar.layer.borderColor = UIColor.white.cgColor
        self.whatThePriceButton.layer.borderColor = UIColor.white.cgColor
        self.findNearestLoctionButton.layer.borderColor = UIColor.white.cgColor
        self.tellUsYourExpirienceButton.layer.borderColor = UIColor.white.cgColor
        self.addAnotherService.layer.borderColor = UIColor.white.cgColor
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView:sideButton )
        
        self.navigationItem.title = "Results"
        
        self.slideMenu.delegate = self
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.calculateOffsetForCollectionItems(self.buttons)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView,
        numberOfItemsInSection section: Int) -> Int{
            return self.buttons.count;
    }
    
    func collectionView(_ collectionView: UICollectionView,
        cellForItemAtIndexPath indexPath: IndexPath) -> UICollectionViewCell{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Identifier", for: indexPath) as! ButtonsCollectionViewCell
            
            cell.title.text = self.buttons[indexPath.row]
            cell.title.textColor = UIColor.white
            cell.backgroundColor = UIColor(red: 30/255.0, green: 104/255.0, blue: 229/255.0, alpha: 1)
            
            if self.selectedButton == indexPath.row{
                cell.title.textColor = UIColor(red: 30/255.0, green: 104/255.0, blue: 229/255.0, alpha: 1)
                cell.backgroundColor = UIColor.white
            }
            
            
            return cell
    }
    
    func collectionView( _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat{
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize{
        
        let string = self.buttons[indexPath.row] as String
        let myString = NSString(string: string)
        let width = myString.boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: self.collectionView.frame.size.height), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName : UIFont.systemFont(ofSize: 14.0)], context: nil).width
        
        let size = CGSize(width: round(width) + 20 + CGFloat(self.offset), height: self.collectionView.frame.size.height)
        return size
    }
    
    func collectionView( _ collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: IndexPath){
        self.selectedButton = indexPath.row
        collectionView.reloadData()
    }
    
    fileprivate func calculateOffsetForCollectionItems(_ array: [String]){
        
        for string in array{
            let myString = NSString(string: string)
            let width = myString.boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: self.collectionView.frame.size.height), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName : UIFont.systemFont(ofSize: 14.0)], context: nil).width
                self.offset += round(width) + 20.0 + 2.0
        }
        if self.offset < self.collectionView.bounds.size.width{
            self.offset = (self.collectionView.bounds.size.width - self.offset) / CGFloat(self.buttons.count)
        }else{
            self.offset = 0.0
        }
        self.collectionView.reloadData()
    }
    
    //MARK: - Private methods
    
    func showSideMenu(_ sender: UIButton?){
        self.slideMenu.isHidden = false
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            if self.sideMenuTralingConstraint.constant == 0{
                self.sideMenuTralingConstraint.constant = -270
                
            }
            else{
                self.sideMenuTralingConstraint.constant = 0
                
            }
            self.view.layoutSubviews()
            },completion: { (finished: Bool) -> Void in
                self.slideMenu.isHidden = self.sideMenuTralingConstraint.constant != 0
                
        });
    }
    
    func resultsSlideDidSelectItem(_ item: ResultsSlideItem){
        self.showSideMenu(nil)
        switch item {
        case .newSearch:
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.5 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: { () -> Void in
                self.navigationController?.popToRootViewController(animated: true)
            })
        case .settings:
            self.performSegue(withIdentifier: ShowSegue.Results.Settings.rawValue, sender: nil)
        }
    }

    //MARK: - IBActions
    
    @IBAction func didCahngeSegment(_ sender: UISegmentedControl) {
        
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ShowSegue.Results.Settings.rawValue{
            
        }
    }
    

}
