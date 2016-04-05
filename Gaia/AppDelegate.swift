//
//  AppDelegate.swift
//  Gaia
//
//  Created by John Henning on 2/3/16.
//  Copyright © 2016 John Henning. All rights reserved.
//

import UIKit
import Parse
import SwiftyBeaver

// Setup SwiftyBeaver Logging
let log = SwiftyBeaver.self
let console = ConsoleDestination()

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var storyboard = UIStoryboard(name: "Main", bundle: nil)
    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        Parse.initializeWithConfiguration(
            ParseClientConfiguration(block: { (configuration:ParseMutableClientConfiguration) -> Void in
                configuration.applicationId = "Gaia-iOS"
                configuration.clientKey = "aSGdoijavm[oaiejtno[qijD-98135812oiijadoij2309uklwjadfj:;DLKJFSOi"
                configuration.server = "https://stark-falls-28866.herokuapp.com/parse"
            })
        )
        
        // Check in with the notifications and see if the logout was called
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "userDidLogout", name: userDidLogoutNotification, object: nil)
        
        // Add SwiftyBeaver
        log.addDestination(console)
        
        
        //Check if there is a user logged in
        if (PFUser.currentUser() != nil) {
            
            // Log Current User Found
            NSLog("Current User " +  (PFUser.currentUser()?.username)! + " Detected as Logged In\n")
            NSLog("Moving to Home View Controller\n")
            
            //Setup vc to move to home contoller
            let vc = storyboard.instantiateViewControllerWithIdentifier("Main") as? ContainerViewController
            
            
            // Set window to vc
            window?.rootViewController = vc
            
        } else {
            
            //Load loginView first
            let LoginVC :LogInViewController = LogInViewController(nibName: "LogInViewController", bundle: nil)
            self.window!.rootViewController = LoginVC;
            
        }
        
        return true
    }
    
    func userDidLogout() {

        let vc :LogInViewController = LogInViewController(nibName: "LogInViewController", bundle: nil)
        self.window!.rootViewController = vc
        
    }


    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

