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
    let sectionInsets = UIEdgeInsets(top: 15.0, left: 17.5, bottom: 15.0, right: 17.5)
    
    // Parse media object
    var content: [PFObject]?
    var imageCache = [Int:UIImage]()
    
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
        
        CatalogueCollectionView.delegate = self
        CatalogueCollectionView.dataSource = self
        
        callServerForUserMedia()
        
        // Do any additional setup after loading the view.
        
        // Create the navigation bar
        let navigationBar = UINavigationBar(frame: CGRectMake(0, 0, (parentViewController?.view.frame.size.width)!, 55)) // Offset by 20 pixels vertically to take the status bar into account
        navigationBar.barTintColor = ThemeHandler.sharedThemeHandler.ComplementaryColor3
        navigationBar.titleTextAttributes = [NSFontAttributeName: ThemeHandler.sharedThemeHandler.ThemeFont!, NSForegroundColorAttributeName: UIColor.whiteColor()]
        // Create a navigation item with a title
        let navigationItem = UINavigationItem()
        navigationItem.title = "Collected Wildlife"
        // Create left and right button for navigation item
        let leftButton =  UIBarButtonItem(title: "Map", style:   UIBarButtonItemStyle.Plain, target: self, action: "btn_clicked:")
        leftButton.setTitleTextAttributes([NSFontAttributeName: ThemeHandler.sharedThemeHandler.ThemeFont!, NSForegroundColorAttributeName: UIColor.whiteColor()], forState: .Normal)
        
        // Create two buttons for the navigation item
        navigationItem.leftBarButtonItem = leftButton
        
        // Assign the navigation item to the navigation bar
        navigationBar.items = [navigationItem]
        
        // Make the navigation bar a subview of the current view controller
        self.view.addSubview(navigationBar)
        
        // Set source & delegate
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "callServerForUserMedia", name: reloadCatalogue, object: nil)
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // Handle Gradient, Buttons, Label Attributes With ThemeHandler
        ThemeHandler.sharedThemeHandler.setFrameGradientTheme(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func callServerForUserMedia() {
        
        // Setup a PFQuery object to handle collection of the user's images
        let query = PFQuery(className: "CaptureMedia").whereKey("username", equalTo: (PFUser.currentUser()?.username)!)
        
        //Caches images from parse
        
        query.orderByDescending("createdAt")
        
        query.cachePolicy = .CacheThenNetwork
        
        query.findObjectsInBackgroundWithBlock { (content: [PFObject]?, error: NSError?) ->
            Void in
            // If we are able to get new userMedia, then set out new media as the new userMedia object
            if let content = content {
                
                // Reset user media object for the tableview data, reload table to display it
                NSLog("Queried data successfully")
                
                for each in content {
                    print("\(each["tag"])")
                }
                
                self.content = content
                self.imageCache.removeAll()
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
        if let content = content {
            return content.count
        }
        else {
            return 0
        }
        
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        // 3
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MyCell", forIndexPath: indexPath) as! CustomCellCollectionViewCell
        // If the media content for this cell exists, set it
        if let img = imageCache[indexPath.row] {
            cell.cellImageView.image = img
        }
        else {
            
            cell.cellImageView.image = UIImage(named: "Gaia iOS App")
            
            if let imageFile = self.content?[indexPath.row]["image"] as? PFFile {
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
                        let portraitImage = UIImage(CGImage: (image?.CGImage)!, scale: 1.0, orientation: UIImageOrientation.Right)
                        
                        // Set image and tag for cell
                        if let updateCell = self.CatalogueCollectionView.cellForItemAtIndexPath(indexPath) as? CustomCellCollectionViewCell {
                            
                            updateCell.cellImageView.image = portraitImage
                        
                        }
                        
                        // Set the cache index
                        self.imageCache[indexPath.row] = portraitImage
                    }
                })
            }
        }
        
        
        // Set the tag
        if let tag = content?[indexPath.row]["tag"]  {
            cell.wildLifeTagCell.text = tag as! String
        }
        
        
        return cell
    }
    func collectionView(collectionView: UICollectionView!,
                        layout collectionViewLayout: UICollectionViewLayout!,
                               sizeForItemAtIndexPath indexPath: NSIndexPath!) -> CGSize {
        
        // Return layout
        return CGSize(width: 130, height: 240)
        
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
        
        let vc = MapViewController()
        vc.content = self.content
        vc.imageCache = self.imageCache
        
        // Present MapView Controller
        presentViewController(vc as UIViewController, animated: true, completion: nil)
        
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
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        // Setup Detail View Controller
        let vc = ImageDetailViewController()
        
        // Pass this current object & img to the controller
        let data = content![indexPath.row]
        vc.content = data
        vc.image = imageCache[indexPath.row]
        
        // Bring up Image Detail Controller
        self.presentViewController(vc, animated: true, completion: nil)
        
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