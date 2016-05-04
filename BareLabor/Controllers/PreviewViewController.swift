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
        self.doneButton.layer.borderColor = UIColor.whiteColor().CGColor
        self.retakeButton.layer.borderColor = UIColor.whiteColor().CGColor
        self.imageView.image = self.image
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.prefersStatusBarHidden()
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didPressRetakeButton(sender: UIButton){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func didPressPlusButton(sender: UIButton){
        if (self.images.count != 2){
            self.images.append(self.image)
            self.navigationController?.popViewControllerAnimated(true)
        }
        else{
            self.plusButton.enabled = false
            self.retakeButton.enabled = false
        }
    }
    
    @IBAction func didPressDoneButton(sender: UIButton)
	{
		activityIndicator.startAnimating()
        Network.sharedInstance.submitEstimateImage(image) { (success) -> () in
			if success
			{
				self.activityIndicator.startAnimating()
				
				let alert = UIAlertController(title: "Success", message: "Please sit tight. We will bring you the estimated pricing shortly. Thank you.", preferredStyle: .Alert)
				let okAction = UIAlertAction(title: "OK", style: .Cancel) { (_) -> Void in
					for controller in self.navigationController!.viewControllers
					{
						if controller is MainMenuViewController
						{
							self.navigationController?.popToViewController(controller, animated: true)
							return
						}
					}
				}
				alert.addAction(okAction)
				self.presentViewController(alert, animated: true, completion: nil)

			} else
			{
				self.activityIndicator.startAnimating()
				
				let alert = UIAlertController(title: "Warning", message: "Could not upload estimate.", preferredStyle: .Alert)
				let okAction = UIAlertAction(title: "OK", style: .Cancel) { (_) -> Void in
					for controller in self.navigationController!.viewControllers
					{
						if controller is MainMenuViewController
						{
							self.navigationController?.popToViewController(controller, animated: true)
							return
						}
					}
				}
				alert.addAction(okAction)
				self.presentViewController(alert, animated: true, completion: nil)
			}
		}
    }
	
    override func prefersStatusBarHidden() -> Bool {
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
