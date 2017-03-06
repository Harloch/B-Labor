//
//  AppDelegate.swift
//  BareLabor
//
//  Dustin Allen
//  Copyright © 2016 BareLabor. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        UINavigationBar.appearance().setBackgroundImage(UIImage(named: "NavigationBar"), for: UIBarMetrics.default)
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        
        
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        
//        let settings = UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil)
//        
//        application.registerUserNotificationSettings( settings )
//        application.registerForRemoteNotifications()
        
        UIApplication.shared.registerForRemoteNotifications()
        
        let settings = UIUserNotificationSettings(types: .alert, categories: nil)
        UIApplication.shared.registerUserNotificationSettings(settings)

        
        return true
    }
    
    // MARK: - Push Notifications
    
    func application( _ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data ) {
        
        let characterSet: CharacterSet = CharacterSet( charactersIn: "<>" )
        
        let deviceTokenString: String = ( deviceToken.description as NSString )
            .trimmingCharacters( in: characterSet )
            .replacingOccurrences( of: " ", with: "" ) as String
        
        print( deviceTokenString )
        UserDefaults.standard.set(deviceTokenString, forKey: "device_token")
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Couldn't register: \(error)")
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void)
    {
		debugPrint(userInfo)
		
		if let aps = userInfo["aps"] as? [AnyHashable: Any]
		{
			if let action = aps["action"] as? [AnyHashable: Any],
				let route = action["route"] as? String,
				let request = action["request"], route == "mail/thread1"
			{
				if let chartController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: ChartViewController.storyboardID) as? ChartViewController, let rootNavController = window?.rootViewController as? UINavigationController
				{
                    chartController.prices = [request["lowCost"] as! String, request["averageCost"] as! String, request["highCost"] as! String];
                    
                    if (application.applicationState == .active)
                    {
                        let alert = UIAlertController(title: nil, message: "The pricing for your printed estimate has arrived", preferredStyle: .alert)
                        let callActionHandler = { (action:UIAlertAction!) -> Void in
                            rootNavController.pushViewController(chartController, animated: true)
                        }
                        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler:callActionHandler))
                        rootNavController.present(alert, animated: true, completion: nil)
                    }
                    else{
                        rootNavController.pushViewController(chartController, animated: true)
                    }
				}
			} else
			{
				print("No action or no route or no request")
			}
        }
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

