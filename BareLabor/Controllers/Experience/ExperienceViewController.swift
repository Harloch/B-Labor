//
//  ExperienceViewController.swift
//  BareLabor
//
//  Dustin Allen
//  Copyright © 2016 BareLabor. All rights reserved.
//

import UIKit

enum ExperienceType: Int {
    case negative = 0
    case positive = 1
}

class ExperienceViewController: UIViewController {
    
    @IBOutlet weak var buttonsTopOffset: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.title = "Tell Us Your Experience"
        
        if 480 == UIScreen.main.bounds.size.height {
            self.buttonsTopOffset.constant = -30
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - IBActions
    
    @IBAction func didPosititveNegativeButtonPressed(_ sender: UIButton){
        if let type = ExperienceType(rawValue: sender.tag){
            switch type {
            case .positive:
                self.performSegue(withIdentifier: ShowSegue.Experience.PositiveNegative.rawValue, sender: ExperienceType.positive.rawValue)
            case .negative:
                self.performSegue(withIdentifier: ShowSegue.Experience.PositiveNegative.rawValue, sender: ExperienceType.negative.rawValue)
            }
        }
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ShowSegue.Experience.PositiveNegative.rawValue {
            if let senderValue = sender as? Int, let goType = ExperienceType(rawValue: senderValue) {
                let controller = segue.destination as! PositiveNegativeViewController
                controller.experience = goType
            }
        }
    }
    

}
