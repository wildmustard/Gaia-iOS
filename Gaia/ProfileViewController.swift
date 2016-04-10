//
//  ProfileViewController.swift
//  Gaia
//
//  Created by Carlos Avogadro on 4/7/16.
//  Copyright © 2016 John Henning. All rights reserved.
//

import UIKit
import Parse

let userDidLogoutNotification = "User Logged Out\n"

class ProfileViewController: UIViewController {
    
    internal var score: Int?
    internal var capturedScore = false
    
    
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var profileUsernameLabel: UILabel!
    @IBOutlet weak var profilePictureImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let profileImage = UIImage(named: "Profile_Picture")
        
        //profileImageView = UIImageView(image: profileImage)
        
        profilePictureImage.image = roundImage(profileImage!)
        
        PFUser.currentUser()
        //self.profilePictureImage.layer.cornerRadius = self.profilePictureImage.frame.size.width / 2;
        self.profilePictureImage.clipsToBounds = true;
        
        profileUsernameLabel.text = PFUser.currentUser()?.username
        
        scoreLabel.text = "\((PFUser.currentUser()!["score"] as! Int?)!)"
    

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //Create rounded images
    func roundImage (image:UIImage) -> UIImage {
        
        let size = CGSizeMake(640, 640)
        UIGraphicsBeginImageContext(size)
        let ctx = UIGraphicsGetCurrentContext()
        CGContextAddArc(ctx, 320, 320, 320,0.0, CGFloat(2 * M_PI), 1)
        CGContextClip(ctx)
        CGContextSaveGState(ctx)
        CGContextTranslateCTM(ctx, 0.0, 640)
        CGContextScaleCTM(ctx, 1.0, -1)
        CGContextDrawImage(ctx, CGRectMake(0, 0, 640, 640), image.CGImage)
        CGContextRestoreGState(ctx)
        let finalImage = UIGraphicsGetImageFromCurrentImageContext()
        
        
        UIGraphicsEndImageContext()
        return finalImage
        
    }

    @IBAction func onLogout(sender: AnyObject) {
        
        PFUser.logOutInBackgroundWithBlock { (error: NSError?) ->
            Void in
            
            if let error = error {
                // Log
                NSLog("Error on logout:\n\(error.localizedDescription)")
            }
            else {
                
                // Log
                NSLog("Logout Success")
                //Broadcast
                NSNotificationCenter.defaultCenter().postNotificationName(userDidLogoutNotification, object: nil)
                
            }
            
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
