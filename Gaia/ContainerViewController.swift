//
//  ContainerViewController.swift
//  Gaia
//
//  Created by Alex Clark on 3/8/16.
//  Copyright © 2016 John Henning. All rights reserved.
//

import UIKit

class ContainerViewController: UIViewController, UIScrollViewDelegate {

    // Scroll View
    @IBOutlet weak var scrollView: UIScrollView!
    
    // Setup Views for Scroll View Container Swipe
    let ScoreVC :ScoreViewController = ScoreViewController(nibName: "ScoreViewController", bundle: nil)
    let CatalogueVC :ImageCatalogueViewController = ImageCatalogueViewController(nibName: "ImageCatalogueViewController", bundle: nil)
    let HomeVC :HomeViewController = HomeViewController(nibName: "HomeViewController", bundle: nil)
    
    // Variables
    var sessionRunning = false // Flag test for the session running

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add Child Views to Container View Hierarchy
        self.addChildViewController(ScoreVC)
        self.scrollView!.addSubview(ScoreVC.view)
        ScoreVC.didMoveToParentViewController(self)
        
        self.addChildViewController(CatalogueVC)
        self.scrollView!.addSubview(CatalogueVC.view)
        CatalogueVC.didMoveToParentViewController(self)
        
        self.addChildViewController(HomeVC)
        self.scrollView!.addSubview(HomeVC.view)
        HomeVC.didMoveToParentViewController(self)
        
        // Setup frame locations for the views
        var catalogueFrame :CGRect = CatalogueVC.view.frame
        catalogueFrame.origin.x = catalogueFrame.width
        HomeVC.view.frame = catalogueFrame
        
        var homeFrame :CGRect = HomeVC.view.frame
        homeFrame.origin.x = 2 * homeFrame.width
        ScoreVC.view.frame = homeFrame
        
        // Setup height of views
        let scrollWidth :CGFloat = 3 * self.view.frame.width
        let scrollHeight : CGFloat = self.view.frame.size.width
        self.scrollView!.contentSize = CGSizeMake(scrollWidth, scrollHeight)
        
        // Delegate control of the scrollview
        scrollView.delegate = self
        
        // Set session flag
        sessionRunning = true
        
        // Broadcast listeners checking is Homeview needs to cancel scrolling for a user capturing an image
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "lockScrollView", name: userCapturedImage, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "unlockScrollView", name: userReleasedImage, object: nil)
        
        
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        
       let scrollContentOffset = scrollView.contentOffset
        
        if((sessionRunning && scrollContentOffset.x == 0) || (sessionRunning && scrollContentOffset.x == 640)) {
            // View has left the homeview, stop the camera session
            HomeVC.session.stopRunning()
            // Broadcast stop of camera
            self.sessionRunning = false
            NSLog("Stopped running session\n")
        }
        else if(!sessionRunning && scrollContentOffset.x == 320) {
            // View has returned to homeview, start the camera session
            HomeVC.session.startRunning()
            // Broadcast start of camera
            self.sessionRunning = true
            NSLog("Session is running\n")
        }
        
        // Log position of scrollview window at x
        NSLog("\(scrollContentOffset)")
        
    }
    
    
    // Disable scrolling
    func lockScrollView() {
        scrollView.scrollEnabled = false
    }
    
    // Enable scrolling
    func unlockScrollView() {
        scrollView.scrollEnabled = true
    }
    
    override func viewWillAppear(animated: Bool) {
        
        // Setup origin for container view to appear on the Home View
        var frame :CGRect = scrollView.frame
        frame.origin.x = frame.size.width
        scrollView.scrollRectToVisible(frame, animated: false)

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
