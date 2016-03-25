//
//  ImageCatalogueViewController.swift
//  Gaia
//
//  Created by Alex Clark on 3/8/16.
//  Copyright © 2016 John Henning. All rights reserved.
//

import UIKit
import Parse
import SVProgressHUD

class ImageCatalogueViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    
    // Set insets for collection cell, size of cell inset separation
    let sectionInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
    
    // Parse media object
    var media: [PFObject]?
    // Refresh controller
    var refreshControl: UIRefreshControl!
    
    // Catalogue collection view
    @IBOutlet var CatalogueCollectionView: UICollectionView!
    
    convenience init() {
        //Calling the designated initializer of same class
        self.init(nibName: "ImageCatalogueViewController", bundle: nil)
        //initializing the view Controller form specified NIB file
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Load Cell file to be registered with CollectionViewController
        let nibName = UINib(nibName: "CustomCellCollectionViewCell", bundle:nil)
        
        //Associate cell with CollectionViewController
        self.CatalogueCollectionView.registerNib(nibName, forCellWithReuseIdentifier: "MyCell")
        
        // self.CatalogueCollectionView.backgroundColor = UIColor(red: 1, green: 165/255, blue: 0, alpha: 1)
        
        // PullDown Refresh control setup
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "onRefresh", forControlEvents: UIControlEvents.ValueChanged)
        CatalogueCollectionView.insertSubview(refreshControl, atIndex: 0)
        CatalogueCollectionView.allowsMultipleSelection = false
        
        
        // Do any additional setup after loading the view.
        
        // Create the navigation bar
        let navigationBar = UINavigationBar(frame: CGRectMake(0, 0, self.view.frame.size.width, 47)) // Offset by 20 pixels vertically to take the status bar into account
        
        navigationBar.backgroundColor = UIColor.whiteColor()
        //navigationBar.delegate = self;
        navigationBar.translucent = true
        
        // Create a navigation item with a title
        let navigationItem = UINavigationItem()
        navigationItem.title = "Collected Wildlife"
        
        // Create left and right button for navigation item
        let leftButton =  UIBarButtonItem(title: "Map", style:   UIBarButtonItemStyle.Plain, target: self, action: "btn_clicked:")
        
        // Create two buttons for the navigation item
        navigationItem.leftBarButtonItem = leftButton
        
        // Assign the navigation item to the navigation bar
        navigationBar.items = [navigationItem]
        
        // Make the navigation bar a subview of the current view controller
        self.view.addSubview(navigationBar)
        
        // Set source & delegate
        CatalogueCollectionView.delegate = self
        CatalogueCollectionView.dataSource = self
        
        callServerForUserMedia()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func callServerForUserMedia() {
        
        // Setup a PFQuery object to handle collection of the user's images
        let query = PFQuery(className: "CaptureMedia")
        
        query.orderByDescending("createdAt")
        
        
        query.findObjectsInBackgroundWithBlock { (media: [PFObject]?, error: NSError?) ->
            Void in
            // If we are able to get new userMedia, then set out new media as the new userMedia object
            if let media = media {
                
                // Reset user media object for the tableview data, reload table to display it
                self.media = media
                self.CatalogueCollectionView.reloadData()
                
                
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
    
    
    //Number of pictures going to be displayed in catalogue
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        //Returns Items in server
        if let media = media {
            return media.count
        }
        else {
            return 0
        }
        
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        // 3
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MyCell", forIndexPath: indexPath) as! CustomCellCollectionViewCell
        
        // If the media content for this cell exists, set it
        if (media?[indexPath.row]["image"] != nil && media?[indexPath.row]["tag"] != nil) {
            
            // Create image and tag properties
            let imageFile = media?[indexPath.row]["image"] as! PFFile
            let imageTag = media?[indexPath.row]["tag"] as! String
            
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
                    let portraitImage = UIImage(CGImage: (image?.CGImage)!,scale: 1.0,orientation: UIImageOrientation.Right)
                    
                    // Set image and tag for cell
                    cell.cellImageView.image = portraitImage
                    cell.wildLifeTagCell.text = imageTag
                    
                    
                    // UIImage(CGImage: cgImageRef!,scale: 1.0,orientation: UIImageOrientation.Right)
                }
            })
        }
            
        else {
            
            // Log Failure
            NSLog("Unable to get image data or tag data")
            
        }
        
        
        return cell
    }
    func collectionView(collectionView: UICollectionView!,
                        layout collectionViewLayout: UICollectionViewLayout!,
                               sizeForItemAtIndexPath indexPath: NSIndexPath!) -> CGSize {
        
        // Return layout
        return CGSize(width: 130, height: 229)
        
    }
    
    
    
    
    func collectionView(collectionView: UICollectionView!,
                        layout collectionViewLayout: UICollectionViewLayout!,
                               insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        
        // Set separation between collection images
        return sectionInsets
        
    }
    
    //Programatically created function to segue into MapViewController
    func btn_clicked(sender: UIBarButtonItem) {
        
        NSLog("Map button clicked, transition started to map")
        
        // Present MapView Controller
        presentViewController((MapViewController() as? UIViewController)!, animated: true, completion: nil)
        
    }
    
    // Set Our Delay
    func delay(delay:Double, closure:()->()) {
        
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
        
    }
    
    // Call the PullDown Refresh on user gesture
    func onRefresh() {
        
        // Start SVProgressHUD
        SVProgressHUD.show()
        
        // Timer for refresh to be shown
        delay(2, closure: {
            self.refreshControl.endRefreshing()
            
            // Dismiss SVProgressHUD
            SVProgressHUD.dismiss()
        })
        
        // Call server for content
        callServerForUserMedia()
        
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
// func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
// 1
// Return the number of sections
//   return 1
// }