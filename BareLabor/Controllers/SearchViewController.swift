//
//  SearchViewController.swift
//  BareLabor
//
//  Dustin Allen
//  Copyright © 2016 BareLabor. All rights reserved.
//

import UIKit

class SearchViewController: BaseViewController, UITextFieldDelegate {

    @IBOutlet weak var inputCarInfoView: CarInfoView!
    @IBOutlet weak var searchTextField: UITextField!
    
    var inputCarInfo: CarInfo!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        self.inputCarInfoView.setYear(self.inputCarInfo.year, make: self.inputCarInfo.make, model: self.inputCarInfo.model, engineSize: self.inputCarInfo.engineSize)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - UITextFieldDelegate Method
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if "" != textField.text {
            self.performSegue(withIdentifier: ShowSegue.Search.PartsAndLabor.rawValue, sender: nil)
        }
        return true
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == ShowSegue.Search.PartsAndLabor.rawValue {
            let controller = segue.destination as! PartsAndLaborViewController
            controller.searchText = self.searchTextField.text
            controller.inputCarInfo = self.inputCarInfo
        }
    }
}
