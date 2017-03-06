//
//  PartsAndLaborViewController.swift
//  BareLabor
//
//  Dustin Allen
//  Copyright © 2016 BareLabor. All rights reserved.
//

import UIKit

private enum ParkingBrake: Int {
    case cable = 0
    case releaseCable = 1
    case shoe = 2
    case assembly = 3
}

class PartsAndLaborViewController: BaseViewController {

    @IBOutlet weak var inputCarInfoView: CarInfoView!
    @IBOutlet weak var parkingBrakeCableButton: UIButton!
    @IBOutlet weak var parkingBrakeReleaseCableButton: UIButton!
    @IBOutlet weak var parkingBrakeShoeButton: UIButton!
    @IBOutlet weak var parkingBrakeAssemblyButton: UIButton!
    
    var inputCarInfo: CarInfo!
    var searchText: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Parts & Labor"
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        self.inputCarInfoView.setYear(self.inputCarInfo.year, make: self.inputCarInfo.make, model: self.inputCarInfo.model, engineSize: self.inputCarInfo.engineSize)
        
        self.parkingBrakeCableButton.titleLabel?.numberOfLines = 2
        self.parkingBrakeCableButton.titleLabel?.textAlignment = .center
        self.parkingBrakeCableButton.setTitle("Remove & Replace\nParking Brake Cable", for: UIControlState())
        
        self.parkingBrakeReleaseCableButton.titleLabel?.numberOfLines = 2
        self.parkingBrakeReleaseCableButton.titleLabel?.textAlignment = .center
        self.parkingBrakeReleaseCableButton.setTitle("Remove & Replace\nParking Brake Release Cable", for: UIControlState())
        
        self.parkingBrakeShoeButton.titleLabel?.numberOfLines = 2
        self.parkingBrakeShoeButton.titleLabel?.textAlignment = .center
        self.parkingBrakeShoeButton.setTitle("Remove & Replace\nParking Brake Shoe", for: UIControlState())
        
        self.parkingBrakeAssemblyButton.titleLabel?.numberOfLines = 2
        self.parkingBrakeAssemblyButton.titleLabel?.textAlignment = .center
        self.parkingBrakeAssemblyButton.setTitle("Remove & Replace\nParking Brake Assembly", for: UIControlState())
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func parkingButtonPressed(_ sender: UIButton){
        
        if let type = ParkingBrake(rawValue: sender.tag) {
            switch type {
            case .cable:
                self.performSegue(withIdentifier: ShowSegue.PartsAndLabor.Results.rawValue, sender: nil)
            case .releaseCable:
                self.performSegue(withIdentifier: ShowSegue.PartsAndLabor.Results.rawValue, sender: nil)
            case .shoe:
                self.performSegue(withIdentifier: ShowSegue.PartsAndLabor.Results.rawValue, sender: nil)
            case .assembly:
                self.performSegue(withIdentifier: ShowSegue.PartsAndLabor.Results.rawValue, sender: nil)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == ShowSegue.PartsAndLabor.Results.rawValue {
            
//            if let senderValue = sender as? Int, goType = ParkingBrake(rawValue: senderValue) {
//                
//                let controller = segue.destinationViewController as! ResultsViewController
//                
//                
//            }
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
