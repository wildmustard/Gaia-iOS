//
//  ImageDetailViewController.swift
//  Gaia
//
//  Created by Alex Clark on 4/1/16.
//  Copyright © 2016 John Henning. All rights reserved.
//

import UIKit
import Parse

class ImageDetailViewController: UIViewController {
    
    weak var content: PFObject?
    weak var image: UIImage?

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var closeButton: UIButton!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Set image to the passed image from presenting ImageCatalgoueController
        imageView.image = self.image
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Pressing Close Button
    @IBAction func onPressClose(sender: AnyObject) {
        
        // Close this view controller
        self.dismissViewControllerAnimated(true, completion: nil)
        
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
