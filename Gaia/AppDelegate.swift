//
//  AppDelegate.swift
//  Gaia
//
//  Created by John Henning on 2/3/16.
//  Copyright © 2016 John Henning. All rights reserved.
//

import UIKit
import Parse


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
  // var tabViewController1 : MapViewController?
   // var tabViewController2 : ImageCatalogueViewController?
    
    
    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        Parse.initializeWithConfiguration(
            ParseClientConfiguration(block: { (configuration:ParseMutableClientConfiguration) -> Void in
                configuration.applicationId = "Gaia-iOS"
                configuration.clientKey = "aSGdoijavm[oaiejtno[qijD-98135812oiijadoij2309uklwjadfj:;DLKJFSOi"
                configuration.server = "https://stark-falls-28866.herokuapp.com/parse"
            })
        )
        
       // window = UIWindow(frame: UIScreen.mainScreen().bounds)
        //setting the initial screen bounds of the view
     //   self.tabViewController1 = MapViewController()
     //   self.tabViewController2 = ImageCatalogueViewController()
        //creating object of TabViewController[1,2,3] class
     //   var tabBarController = UITabBarController()
        //creating object of UITabBarController class
    //    tabBarController.viewControllers = [tabViewController1! , tabViewController2!]
        //adding all three views to the TabBarView
      //  var item1 = UITabBarItem(title: "1st Tab", image: nil, tag: 0)
    //    var item2 = UITabBarItem(title: "2nd Tab", image: nil, tag: 1)
        //defining the items of the TabBar corresponding to three views
   //     tabViewController1?.tabBarItem = item1
    //    tabViewController2?.tabBarItem = item2
        //setting TabBarItems corresponding to each view in TabBarController
        
        //self.window?.rootViewController = containerViewController
        //setting the initial VieController as tabBarController
        
       // window?.makeKeyAndVisible()
        
        
        
        return true
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

