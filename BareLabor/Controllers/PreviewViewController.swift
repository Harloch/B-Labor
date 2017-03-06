//
//  PreviewViewController.swift
//  BareLabor
//
//  Dustin Allen
//  Copyright © 2016 BareLabor. All rights reserved.
//

import UIKit

class PreviewViewController: UIViewController {

    @IBOutlet weak var imageView : UIImageView!
    @IBOutlet weak var doneButton : UIButton!
    @IBOutlet weak var retakeButton : UIButton!
    @IBOutlet weak var plusButton : UIButton!
    
	@IBOutlet var activityIndicator: UIActivityIndicatorView!
	
    var image : UIImage!
    var images : [UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.doneButton.layer.borderColor = UIColor.white.cgColor
        self.retakeButton.layer.borderColor = UIColor.white.cgColor
        self.imageView.image = self.image
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.prefersStatusBarHidden
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didPressRetakeButton(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didPressPlusButton(_ sender: UIButton){
        if (self.images.count != 2){
            self.images.append(self.image)
            self.navigationController?.popViewController(animated: true)
        }
        else{
            self.plusButton.isEnabled = false
            self.retakeButton.isEnabled = false
        }
    }
    
    @IBAction func didPressDoneButton(_ sender: UIButton)
	{
        self.activityIndicator.startAnimating()
        (DispatchQueue.global(qos: DispatchQoS.QoSClass.background)).async(execute: {
            Network.sharedInstance.submitEstimateImage(self.image) { (success) -> () in
                if success
                {
                    print("Upload success")
                } else
                {
                    print("Upload failed")
                }
            }
        })
        let alert = UIAlertController(title: "Success", message: "Please sit tight. We will bring you the estimated pricing shortly. Thank you.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel) { (_) -> Void in
            let mainMenuViewController = self.storyboard?.instantiateViewController(withIdentifier: "MainMenuViewController") as! MainMenuViewController!
            self.navigationController?.pushViewController(mainMenuViewController!, animated: true)
        }
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
        
    }
	
    override var prefersStatusBarHidden : Bool {
        return true
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
