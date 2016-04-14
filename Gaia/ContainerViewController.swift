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
    let TabVC = TabBarContainerViewController(nibName: "TabBarContainerViewController", bundle: nil)
    let CatalogueVC :ImageCatalogueViewController = ImageCatalogueViewController(nibName: "ImageCatalogueViewController", bundle: nil)
    let HomeVC :HomeViewController = HomeViewController(nibName: "HomeViewController", bundle: nil)
    
    let ScoreVC = ScoreViewController(nibName: "ScoreViewController", bundle: nil)
    let ProfileVC = ProfileViewController(nibName: "ProfileViewController",bundle: nil)
    
    
    // Variables
    var sessionRunning = false // Flag test for the session running

    override func viewDidLoad() {
        super.viewDidLoad()
        //Links score viewController and profile VC to the tab bar ViewController
        TabVC.firstViewController = ScoreVC
        TabVC.secondViewController = ProfileVC

        
        //uncomment when database is reset
        
        /*let wildlife = Wildlife()
        
        wildlife.serverPost()
         
        */
        
        // Add Child Views to Container View Hierarchy
        self.addChildViewController(TabVC)
        self.scrollView!.addSubview(TabVC.view)
        TabVC.didMoveToParentViewController(self)
        
        self.addChildViewController(CatalogueVC)
        self.scrollView!.addSubview(CatalogueVC.view)
        CatalogueVC.didMoveToParentViewController(self)
        
        self.addChildViewController(HomeVC)
        self.scrollView!.addSubview(HomeVC.view)
        HomeVC.didMoveToParentViewController(self)
        
        
        // Delegate control of the scrollview
        scrollView.delegate = self
        
        // Set session flag
        sessionRunning = true
        
        // Broadcast listeners checking is Homeview needs to cancel scrolling for a user capturing an image
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "lockScrollView", name: userCapturedImage, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "unlockScrollView", name: userReleasedImage, object: nil)
        
        
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        
        // Grab scroll offset from scrollview position on end of deacceleration
       let scrollContentOffset = scrollView.contentOffset
        
        // Based on scroll content offset value, we can determine which frame we are in
        // We can determine the last frame we were in before controller was unloaded
        switch (scrollContentOffset.x) {
        case 0.0: // Image Catalogue
            currentFrameReturnIndex = 0
        case (2 * scrollView.frame.size.width): // Score
            currentFrameReturnIndex = 2
        default: // Home
            currentFrameReturnIndex = 1
        }
        
//        if((sessionRunning && scrollContentOffset.x == 0) || (sessionRunning && scrollContentOffset.x == 640)) {
//            // View has left the homeview, stop the camera session
//            //HomeVC.session.stopRunning()
//            // Broadcast stop of camera
//            self.sessionRunning = false
//            NSLog("Stopped running session\n")
//        }
//        else if(!sessionRunning && scrollContentOffset.x == 320) {
//            // View has returned to homeview, start the camera session
//            //HomeVC.session.startRunning()
//            // Broadcast start of camera
//            self.sessionRunning = true
//            NSLog("Session is running\n")
//        }
        
        // Log position of scrollview window at x
        log.debug("Current Scroll Content Offset: \(scrollContentOffset)")
        // Log Index on change
        log.debug("Current Frame Index To Return To: \(currentFrameReturnIndex)")
        
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
        var frame :CGRect = self.view.frame
        scrollView.frame = frame
        
        // Setup height of views
        let scrollWidth :CGFloat = 3 * frame.width
        let scrollHeight :CGFloat = frame.height
        self.scrollView!.contentSize = CGSizeMake(scrollWidth, scrollHeight)
        
        // Setup frame locations for the views
        CatalogueVC.view.frame.size.width = frame.width
        CatalogueVC.view.frame.size.height = frame.height
        var catalogueFrame :CGRect = CatalogueVC.view.frame
        catalogueFrame.origin.x = catalogueFrame.width
        HomeVC.view.frame = catalogueFrame
        var homeFrame :CGRect = HomeVC.view.frame
        homeFrame.origin.x = 2 * homeFrame.width
        TabVC.view.frame = homeFrame
        
        // Set the origin of the frame to the current returning frame
        frame.origin.x = getCurrentReturnFrameOrigin()
        scrollView.scrollRectToVisible(frame, animated: false)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Function to return the current frame index for returning origin on dismissing subview controller
    func getCurrentReturnFrameOrigin() -> CGFloat! {
        
        // Case of the returning frame index
        switch (currentFrameReturnIndex) {
        case 0: // Image Catalogue
            return 0.0
        case 2: // Score
            return 2 * self.view.frame.size.width
        default: // Home
            return self.view.frame.size.width
        }
        
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
