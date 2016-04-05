//
//  MapViewController.swift
//  Gaia
//
//  Created by Carlos Avogadro on 3/13/16.
//  Copyright © 2016 John Henning. All rights reserved.
//

import UIKit
import Parse
import MapKit

class MapViewController: UIViewController {
    
    var content: [PFObject]?
    var imageCache = [Int:UIImage]()
    
    @IBOutlet weak var mapView: MKMapView!
    
    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?, content: [PFObject], imageCache: [Int:UIImage]) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.content = content
        self.imageCache = imageCache
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
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
    
    //Dismisses current view and returns to homeView, have to fix, should return to catalogue view
    @IBAction func onBack(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: {
        })
        
    }

}
