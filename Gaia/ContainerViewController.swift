//
//  ContainerViewController.swift
//  Gaia
//
//  Created by Alex Clark on 3/8/16.
//  Copyright © 2016 John Henning. All rights reserved.
//

import UIKit

class ContainerViewController: UIViewController {

    // Scroll View
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup Views for Scroll View Container Swipe
        let ScoreVC :ScoreViewController = ScoreViewController(nibName: "ScoreViewController", bundle: nil)
        let CatalogueVC :ImageCatalogueViewController = ImageCatalogueViewController(nibName: "ImageCatalogueViewController", bundle: nil)
        let HomeVC :HomeViewController = HomeViewController(nibName: "HomeViewController", bundle: nil)

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
