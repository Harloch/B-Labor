//
//  BaseViewController.swift
//  BareLabor
//
//  Dustin Allen
//  Copyright © 2016 BareLabor. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(BaseViewController.onLocationDenied(_:)), name: NSNotification.Name(rawValue: Notifications.Location.StatusDenied.rawValue), object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: Notifications.Location.StatusDenied.rawValue), object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Notification Observer
    
    func onLocationDenied(_ sender: Notification) {
        
        let alert = UIAlertController(title: "Warning", message: "Please turn on location in the Settings", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Settings", style: .default, handler: { (_) -> Void in
            UIApplication.shared.openURL(URL(string: UIApplicationOpenSettingsURLString)!)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Public Method
    
    func showNotificationAlertWithTitle(_ title: String?, message: String?, cancelButtonTitle: String!, actionHandler: ((Void) -> Void)?) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: cancelButtonTitle, style: .cancel, handler: { (action) -> Void in
            if nil != actionHandler {
                actionHandler!()
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
