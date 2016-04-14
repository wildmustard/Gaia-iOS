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
import SVProgressHUD

class ImageDetailViewController: UIViewController, UIWebViewDelegate {
    
    weak var content: PFObject?
    weak var image: UIImage?
    var wiki: NSURLRequest?

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var closeButton: UIButton!
    
    @IBOutlet weak var arrowImageView: UIImageView!
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var trayView: UIView!
    @IBOutlet weak var buttonView: UIView!
    
    var trayOriginalCenter: CGPoint!
    var trayCenterWhenOpen: CGPoint!
    var trayCenterWhenClosed: CGPoint!
    var initialLoad : Bool?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        initialLoad = true
        webView.delegate = self
        
        print(view.frame.size.height)
        

        
        // Set image to the passed image from presenting ImageCatalgoueController
        
        imageView.image = self.image
        let url = NSURL(string: (self.content!["wiki"] as? String)!)
        self.wiki = NSURLRequest(URL: url!, cachePolicy: NSURLRequestCachePolicy.ReturnCacheDataElseLoad, timeoutInterval: 20)
        webView.loadRequest(self.wiki!)
    }
    
    //gets called when subviews have been set with autolayout
    
    override func viewDidLayoutSubviews() {
        if initialLoad! {
            trayCenterWhenOpen = trayView.center
            trayCenterWhenClosed = trayView.center
            trayCenterWhenClosed.y = trayCenterWhenClosed.y + view.frame.size.height - 50
            trayView.center = trayCenterWhenClosed
            print("trayView viewlayoutsubviews: \n \(trayView.center) \n \(trayCenterWhenClosed)")
        }
        
    }
    
    
    override func viewDidAppear(animated: Bool) {
        initialLoad = false
        print("trayView viewdidappear: \n \(trayView.center) \n \(trayCenterWhenClosed)")
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
        
        //print(self.trayView.center)
        // Absolute (x,y) coordinates in parent view's coordinate system
        let point = panGestureRecognizer.locationInView(trayView)
        
        // Total translation (x,y) over time in parent view's coordinate system
        
        if panGestureRecognizer.state ==
            UIGestureRecognizerState.Began {
            
            //print("Gesture began at: \(point)")
            self.trayOriginalCenter = trayView.center
            
            
        } else if panGestureRecognizer.state == UIGestureRecognizerState.Changed {
            
            //print("Gesture changed at: \(point)")
            if panGestureRecognizer.velocityInView(self.trayView).y > 0 {
                UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.75, initialSpringVelocity: 0.2, options: .AllowUserInteraction, animations: { () -> Void in
                    self.trayView.center = self.trayCenterWhenClosed
                    self.arrowImageView.highlighted = false
                    }, completion: { (Bool) -> Void in
                        //print("yay")
                })
                
                
            } else if panGestureRecognizer.velocityInView(self.trayView).y < 0 {
                UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.75, initialSpringVelocity: 0.2, options: .AllowUserInteraction, animations: { () -> Void in
                    self.trayView.center = self.trayCenterWhenOpen
                    self.arrowImageView.highlighted = true
                    if self.webView.loading {
                        SVProgressHUD.show()
                    }
                    }, completion: { (Bool) -> Void in
                        //print("yay")
                })
                
            }
            
        } else if panGestureRecognizer.state == UIGestureRecognizerState.Ended {
            
            //print("Gesture ended at: \(point)")
            
        }

    }
    @IBAction func onTrayTapGesture(sender: UITapGestureRecognizer) {
        if self.trayView.center == trayCenterWhenClosed {
            UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.75, initialSpringVelocity: 0.1, options: .AllowUserInteraction, animations: { () -> Void in
                self.trayView.center = self.trayCenterWhenOpen
                self.arrowImageView.highlighted = true
                
                if self.webView.loading {
                    SVProgressHUD.show()
                }
                }, completion: { (Bool) -> Void in
                    //print("yay")
            })
        }
        else if self.trayView.center == trayCenterWhenOpen {
            UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.75, initialSpringVelocity: 0.1, options: .AllowUserInteraction, animations: { () -> Void in
                self.trayView.center = self.trayCenterWhenClosed
                self.arrowImageView.highlighted = false
                }, completion: { (Bool) -> Void in
                    //print("yay")
            })
        }
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        SVProgressHUD.dismiss()
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
