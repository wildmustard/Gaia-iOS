//
//  TabBarContainerViewController.swift
//  Gaia
//
//  Created by Carlos Avogadro on 4/9/16.
//  Copyright © 2016 John Henning. All rights reserved.
//

import UIKit
import ChameleonFramework
import ZFRippleButton

class TabBarContainerViewController: UIViewController {

    var firstViewController: UIViewController?
    var secondViewController: UIViewController?
    var activeTab = 0

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var tabNavigationView: UIView!
    @IBOutlet weak var profileButton: ZFRippleButton!
    @IBOutlet weak var leaderboardsButton: ZFRippleButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Load first view (Profile Viewcontroller) by default
        activeViewController = firstViewController
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // Handle Gradient, Buttons, Label Attributes With ThemeHandler
        ThemeHandler.sharedThemeHandler.setTabZFRippleButtonThemeAttributes(profileButton)
        ThemeHandler.sharedThemeHandler.setTabZFRippleButtonThemeAttributes(leaderboardsButton)
        setTabButtonActivity()
    }

    private var activeViewController: UIViewController? {
        didSet {
            removeInactiveViewController(oldValue)
            updateActiveViewController()
        }
    }
    
    private func removeInactiveViewController(inactiveViewController: UIViewController?) {
        if let inActiveVC = inactiveViewController {
            // call before removing child view controller's view from hierarchy
            inActiveVC.willMoveToParentViewController(nil)
            inActiveVC.view.removeFromSuperview()
            // call after removing child view controller's view from hierarchy
            inActiveVC.removeFromParentViewController()
        }
    }
    
    private func updateActiveViewController() {
        if let activeVC = activeViewController {
            // call before adding child view controller's view as subview
            addChildViewController(activeVC)
            activeVC.view.frame = contentView.bounds
            contentView.addSubview(activeVC.view)
            // call before adding child view controller's view as subview
            activeVC.didMoveToParentViewController(self)
        }
    }
    
    //Switch to first (Profile) ViewController
    @IBAction func didTapFirstButton(sender: AnyObject) {
        setTabButtonActivity()
        activeViewController = firstViewController
    }
    
    //Switch to first (Score) ViewController
    @IBAction func didTapSecondButton(sender: AnyObject) {
        setTabButtonActivity()
        activeViewController = secondViewController
    }
    
    private func setTabButtonActivity() {
        if (activeTab == 0) {
            activeTab = 1
            ThemeHandler.sharedThemeHandler.switchTabZFRippleButtonActivity(profileButton, on: true)
            ThemeHandler.sharedThemeHandler.switchTabZFRippleButtonActivity(leaderboardsButton, on: false)
        }
        else {
            activeTab = 0
            ThemeHandler.sharedThemeHandler.switchTabZFRippleButtonActivity(profileButton, on: false)
            ThemeHandler.sharedThemeHandler.switchTabZFRippleButtonActivity(leaderboardsButton, on: true)
        }
    }
}
