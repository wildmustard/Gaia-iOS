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
    
    internal var content: [PFObject]?
    internal var imageCache = [Int:UIImage]()
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var testLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        testLabel.text = (self.content![0]["tag"] as! String)
        testLabel.sizeToFit()
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
