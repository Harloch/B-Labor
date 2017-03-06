//
//  ScanViewController.swift
//  BareLabor
//
//  Dustin Allen
//  Copyright © 2016 BareLabor. All rights reserved.
//

import UIKit

class ScanViewController: BaseViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var topBarView: UIView?
    @IBOutlet weak var takePictureButton: UIButton?
    var activityIndicatorView: UIActivityIndicatorView?
    
    var imagePicker : UIImagePickerController = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set title viewController title
        self.navigationItem.title = "Scan"
        // Hide statusBar
        self.prefersStatusBarHidden
        // Get view for custom camera controls from xib and add this view on imagePicker
        if let view = Bundle.main.loadNibNamed("ImagePickerControlsView", owner: self, options: nil)?.first as? UIView {
            view.frame = UIScreen.main.bounds
            
            // Check avalible source type
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                self.takePictureButton?.isEnabled = true
                // Set topBar on cameraView
                self.topBarView?.backgroundColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha:0.5)
                self.topBarView?.isHidden = false
                // Set imagePickerController for showing camera
                self.imagePicker.sourceType = UIImagePickerControllerSourceType.camera
                self.imagePicker.showsCameraControls = false
                self.imagePicker.allowsEditing = false
                self.imagePicker.delegate = self
                self.imagePicker.cameraFlashMode = UIImagePickerControllerCameraFlashMode.auto
                // Make transform for displying camera on whole screen
                let transform = CGAffineTransform(translationX: 0.0, y: 71.0);
                self.imagePicker.cameraViewTransform = transform;
                let scale = transform.scaledBy(x: 1.333333, y: 1.333333);
                self.imagePicker.cameraViewTransform = scale;
                // Add image picker on controller
                self.imagePicker.view.addSubview(view)
                self.view.addSubview(self.imagePicker.view)
            }else{
                self.view.addSubview(view)
                self.topBarView?.isHidden = true
                self.takePictureButton?.isEnabled = false
            }
        } 
    }
    /**
     Hide status bar
     */
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - IBAction methods
    /**
    Change camra source, front or rear
     */
    @IBAction func flipButtonPressed(_ sender: UIButton){
        UIView.transition(with: self.imagePicker.view, duration: 1.0, options: [UIViewAnimationOptions.allowAnimatedContent, UIViewAnimationOptions.transitionFlipFromLeft], animations: { () -> Void in
            if self.imagePicker.cameraDevice == UIImagePickerControllerCameraDevice.rear  {
                self.imagePicker.cameraDevice = UIImagePickerControllerCameraDevice.front;
            } else {
                self.imagePicker.cameraDevice = UIImagePickerControllerCameraDevice.rear;
            }
            
            }, completion: nil)
    }
    /**
     Close cameraCotroller
     */
    @IBAction func closeButton(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    /**
     Take photo
     */
    @IBAction func makePhoto(_ sender: UIButton){
        self.imagePicker.takePicture()
        self.activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .white)
        self.activityIndicatorView?.frame = self.takePictureButton!.bounds
        self.takePictureButton?.addSubview(self.activityIndicatorView!)
        self.activityIndicatorView?.startAnimating()
    }
    /**
     Show library
     */
    @IBAction func libraryPressed(_ sender: UIButton){
        let libraryPickerController = UIImagePickerController()
        libraryPickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
        self.navigationController?.present(libraryPickerController, animated: true, completion: nil)
        libraryPickerController.delegate = self
        
        
    }
    
    // MARK: - UIImagePickerControolerDelegate methods
    func imagePickerController( _ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        if picker.sourceType == UIImagePickerControllerSourceType.photoLibrary{
            self.dismiss(animated: true, completion: nil)
        }
        else{
            self.activityIndicatorView?.stopAnimating()
        }
        
        if let originImage = info["UIImagePickerControllerOriginalImage"]{
            self.performSegue(withIdentifier: ShowSegue.Camera.Preview.rawValue, sender: originImage)
        }
        
        
    }
    
    func imagePickerControllerDidCancel( _ picker: UIImagePickerController){
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Navigation
    /**
    In a storyboard-based application, you will often want to do a little preparation before navigation
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ShowSegue.Camera.Preview.rawValue {
            if let senderValue = sender as? UIImage {
                let controller = segue.destination as! PreviewViewController
                controller.image = senderValue
                
                
            }
        }
    }
    

}
