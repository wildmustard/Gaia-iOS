//
//  ScoreViewController.swift
//  Gaia
//
//  Created by Alex Clark on 3/8/16.
//  Copyright © 2016 John Henning. All rights reserved.
//

import UIKit
import Parse

let userDidLogoutNotification = "User Logged Out\n"


class ScoreViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var currentUsernameLabel: UILabel!
    @IBOutlet weak var userScoreLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var profilePictureImage: UIImageView!
    
    // Parse media object
    var content: [PFObject]?
    var userCache = [Int:String]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Load Cell file to be registered with CollectionViewController
        let nibName = UINib(nibName: "ScoreViewTableCell", bundle:nil)
        
        //Associate cell with CollectionViewController
        self.tableView.registerNib(nibName, forCellReuseIdentifier: "MyScoreCell")
        
        tableView.delegate = self
        
        tableView.dataSource = self
        
        callServerForUserScore()

        let profileImage = UIImage(named: "Profile_Picture")
        
        //profileImageView = UIImageView(image: profileImage)
        
        profilePictureImage.image = roundImage(profileImage!)

        //self.profilePictureImage.layer.cornerRadius = self.profilePictureImage.frame.size.width / 2;
        self.profilePictureImage.clipsToBounds = true;
        
        
        // Reload tableview on post of new capture
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "callServerForUserScore", name: reloadScores, object: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    
    func callServerForUserScore() {
        
        // Setup a PFQuery object to handle collection of the user's scores
        let query = PFQuery(className: "_User")//.whereKey("username", notEqualTo: (PFUser.currentUser()?.username)!)
        
        //Caches images from parse
        
        query.orderByDescending("score")
        
        query.cachePolicy = .CacheThenNetwork
        
        query.findObjectsInBackgroundWithBlock { (content: [PFObject]?, error: NSError?) ->
            Void in
            // If we are able to get new user profiles, then set out new media as the new userMedia object
            if let content = content {
                
                // Reset user media object for the tableview data, reload table to display it
                NSLog("Queried data successfully")
                
                for each in content {
                    print("\(each["username"]) w/ score \(each["score"])")
                }
                
                
                self.content = content
                self.userCache.removeAll()
                self.tableView.reloadData()
                
            }
                // Unable to get new user media
            else {
                if let error = error {
                    // Log error
                    NSLog("Error: Unable to query new user media objects\n\(error)")
                }
                
            }
        }
        
        
    }

    
    func tableView(tableView:UITableView, numberOfRowsInSection section:Int) -> Int {
        return 1
    }
    
    // Number of sections in tableview == number of media objects we gathered, else 0 cells we have to show
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if (content != nil) {
            return content!.count
        }
        else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MyScoreCell", forIndexPath: indexPath) as! ScoreViewTableCell
        
        if (content?[indexPath.section]["username"] != nil && (content?[indexPath.section]["score"] != nil)) {
            let usr = content![indexPath.section]["username"] as! String
            let scr = content![indexPath.section]["score"] as! Int
            
            //Highlight the current user cell
            if (usr == PFUser.currentUser()?.username) {
                //Set the labels next to profile image
               // userScoreLabel.text = "\(scr)"
               // currentUsernameLabel.text = usr
                
                cell.backgroundColor = UIColor.yellowColor()
                cell.usernameLabel.text = usr
                cell.scoreLabel.text = "\(scr)"
                
                }
            else {
                cell.backgroundColor = UIColor.whiteColor()

                cell.usernameLabel.text = usr
                cell.scoreLabel.text = "\(scr)"

                
            }
            
        }
        
       
        
        // Return cell header
        return cell
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
    override func prefersStatusBarHidden() -> Bool {
        return true
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
