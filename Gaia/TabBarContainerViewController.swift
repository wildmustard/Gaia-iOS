//
//  TabBarContainerViewController.swift
//  Gaia
//
//  Created by Carlos Avogadro on 4/9/16.
//  Copyright © 2016 John Henning. All rights reserved.
//

import UIKit

class TabBarContainerViewController: UIViewController {

    var firstViewController: UIViewController?
    var secondViewController: UIViewController?

    @IBOutlet weak var contentView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Load first (Score) Viewcontroller by default 
        activeViewController = firstViewController


        // Do any additional setup after loading the view.
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
    
    //Switch to first (Score) ViewController

    @IBAction func didTapFirstButton(sender: AnyObject) {
        
        activeViewController = firstViewController
    }
    //Switch to first (Profile) ViewController

    @IBAction func didTapSecondButton(sender: AnyObject) {
        
        activeViewController = secondViewController
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
