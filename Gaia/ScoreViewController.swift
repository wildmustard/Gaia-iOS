//
//  ScoreViewController.swift
//  Gaia
//
//  Created by Alex Clark on 3/8/16.
//  Copyright © 2016 John Henning. All rights reserved.
//

import UIKit
import Parse



class ScoreViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    // Parse media object
    var content: [PFObject]?
    var userCache = [Int:UIImage]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Load Cell file to be registered with CollectionViewController
        let nibName = UINib(nibName: "ScoreViewTableCell", bundle:nil)
        
        //Associate cell with CollectionViewController
        self.tableView.registerNib(nibName, forCellReuseIdentifier: "MyScoreCell")
        
        // Set tableview delegation & datasource
        tableView.delegate = self
        tableView.dataSource = self
        
        // Get all users for table
        callServerForUserScore()
        
        // Reload tableview on post of new capture
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "callServerForUserScore", name: reloadScores, object: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // Handle Gradient, Buttons, Label Attributes With ThemeHandler
        ThemeHandler.sharedThemeHandler.setFrameGradientTheme(self)
    }
    
        
    
    func callServerForUserScore() {
        // Setup a PFQuery object to handle collection of all user scores
        let query = PFQuery(className: "_User")
        // Order by highest score and set caching
        query.cachePolicy = .CacheThenNetwork
        query.orderByDescending("score")
        // Always attempt to check network else pull cached data
        query.cachePolicy = .NetworkElseCache
        query.findObjectsInBackgroundWithBlock { (content: [PFObject]?, error: NSError?) ->
            Void in
            // If we are able to get new user profiles, then set out new media as the new userMedia object
            if let error = error {
                // Log error
                log.error("Error: Unable to query new user media objects\n\(error.localizedDescription)")
            }
            else {
                // Reset user media object for the tableview data, reload table to display it
                log.debug("Score table data successfully")
                for each in content! {
                    log.debug("\(each["username"]) w/ score \(each["score"])")
                }
                // Set content
                self.content = content
                // Reload user cache & table data
                self.userCache.removeAll()
                self.tableView.reloadData()
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
        // If the media content for this cell exists, set it
        
        if let img = userCache[indexPath.row] {
            cell.profilePictureView.image = img
        }
        else {
            
            cell.profilePictureView.image = UIImage(named: "Apple_Swift_Logo")
        
        if let imageFile = self.content?[indexPath.row]["profilePicture"] as? PFFile {
            imageFile.getDataInBackgroundWithBlock({ (data: NSData?, error: NSError?) ->
                Void in
                
                // Failure to get image
                if let error = error {
                    
                    // Log Failure
                    NSLog("Unable to get image data for table cell \(indexPath.row)\nError: \(error)")
                    
                }
                    // Success getting image
                else {
                    
                    // Get image and set to cell's content
                    let image = UIImage(data: data!)
                    
                    //let image = UIImage(CGImage: cgImageRef!,scale: 1.0,orientation: UIImageOrientation.Right)
                    let roundProfile = self.roundImage(image!)
                    
                    // Set image and tag for cell
                    if let updateCell = self.tableView.cellForRowAtIndexPath(indexPath) as? ScoreViewTableCell {
                        
                        updateCell.profilePictureView.image = roundProfile
                        
                    }
                    
                    // Set the cache index
                    self.userCache[indexPath.row] = roundProfile
                }
            })
        }
    }

    
    
        if (content?[indexPath.section]["username"] != nil && (content?[indexPath.section]["score"] != nil)) {
            let usr = content![indexPath.section]["username"] as! String
            let scr = content![indexPath.section]["score"] as! Int
            
            //Highlight the current user cell
            if (usr == PFUser.currentUser()?.username) {
                //Set the labels next to profile image
               // userScoreLabel.text = "\(scr)"
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
    
    
    // Hide Status Bar
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
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

}
