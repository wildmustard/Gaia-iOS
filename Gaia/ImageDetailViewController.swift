//
//  ImageDetailViewController.swift
//  Gaia
//
//  Created by Alex Clark on 4/1/16.
//  Copyright © 2016 John Henning. All rights reserved.
//

import UIKit
import Parse
import WebKit

class ImageDetailViewController: UIViewController {
    
    weak var content: PFObject?
    weak var image: UIImage?
    var wiki: NSURLRequest?

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var closeButton: UIButton!
    
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var trayView: UIView!
    @IBOutlet weak var buttonView: UIView!
    
    var trayOriginalCenter: CGPoint!
    var trayCenterWhenOpen: CGPoint!
    var trayCenterWhenClosed: CGPoint!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        trayCenterWhenOpen = trayView.center
        trayCenterWhenClosed = trayView.center
        trayCenterWhenClosed.y = trayCenterWhenClosed.y + view.frame.size.height - 50
        
        trayView.center = trayCenterWhenClosed

        
        // Set image to the passed image from presenting ImageCatalgoueController
        imageView.image = self.image
        let url = NSURL(string: (self.content!["wiki"] as? String)!)
        self.wiki = NSURLRequest(URL: url!, cachePolicy: NSURLRequestCachePolicy.ReturnCacheDataElseLoad, timeoutInterval: 20)
        webView.loadRequest(self.wiki!)
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

    @IBAction func onTrayPanGesture(panGestureRecognizer: UIPanGestureRecognizer) {
        
        // Absolute (x,y) coordinates in parent view's coordinate system
        let point = panGestureRecognizer.locationInView(trayView)
        
        // Total translation (x,y) over time in parent view's coordinate system
        
        if panGestureRecognizer.state ==
            UIGestureRecognizerState.Began {
            
            print("Gesture began at: \(point)")
            self.trayOriginalCenter = trayView.center
            
            
        } else if panGestureRecognizer.state == UIGestureRecognizerState.Changed {
            
            print("Gesture changed at: \(point)")
            if panGestureRecognizer.velocityInView(self.trayView).y > 0 {
                UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.75, initialSpringVelocity: 0.2, options: .AllowUserInteraction, animations: { () -> Void in
                    self.trayView.center = self.trayCenterWhenClosed
                    }, completion: { (Bool) -> Void in
                        //print("yay")
                })
                
                
            } else if panGestureRecognizer.velocityInView(self.trayView).y < 0 {
                UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.75, initialSpringVelocity: 0.2, options: .AllowUserInteraction, animations: { () -> Void in
                    self.trayView.center = self.trayCenterWhenOpen
                    }, completion: { (Bool) -> Void in
                        //print("yay")
                })
                
            }
            
        } else if panGestureRecognizer.state == UIGestureRecognizerState.Ended {
            
            print("Gesture ended at: \(point)")
            
        }

    }
    @IBAction func onTrayTapGesture(sender: UITapGestureRecognizer) {
        if self.trayView.center == trayCenterWhenClosed {
            UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.75, initialSpringVelocity: 0.2, options: .AllowUserInteraction, animations: { () -> Void in
                self.trayView.center = self.trayCenterWhenOpen
                }, completion: { (Bool) -> Void in
                    //print("yay")
            })
        }
        else if self.trayView.center == trayCenterWhenOpen {
            UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.75, initialSpringVelocity: 0.2, options: .AllowUserInteraction, animations: { () -> Void in
                self.trayView.center = self.trayCenterWhenClosed
                }, completion: { (Bool) -> Void in
                    //print("yay")
            })
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
