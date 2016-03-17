//
//  ImageCatalogueViewController.swift
//  Gaia
//
//  Created by Alex Clark on 3/8/16.
//  Copyright © 2016 John Henning. All rights reserved.
//

import UIKit
import Parse

class ImageCatalogueViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    
    //Set insets for collection
    let sectionInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
    
    var media: [PFObject]?
    
    
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

    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        //#warning Incomplete method implementation -- Return the number of sections
        return 1
    }
    
    //Number of pictures going to be displayed in catalogue
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       //Returns Items in server
        
        if (media != nil) {
            return media!.count
        }
        else {
            return 0
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        // 3
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MyCell", forIndexPath: indexPath) as? CustomCellCollectionViewCell
        
        // If the media content for this cell exists, set it
        if (media?[indexPath.section]["image"] != nil) {
            let imageFile = media?[indexPath.section]["image"] as! PFFile
            imageFile.getDataInBackgroundWithBlock({ (data: NSData?, error: NSError?) ->
                Void in
                
                // Failure to get image
                if let error = error {
                    // Log Failure
                    NSLog("Unable to get image data for table cell \(indexPath.section)\nError: \(error)")
                }
                    // Success getting image
                else {
                    // Get image and set to cell's content
                    let image = UIImage(data: data!)
                    
                    //let image = UIImage(CGImage: cgImageRef!,scale: 1.0,orientation: UIImageOrientation.Right)
                    let portraitImage = UIImage(CGImage: (image?.CGImage)!,scale: 1.0,orientation: UIImageOrientation.Right)
                    
                    cell?.cellImageView.image = portraitImage
                   // UIImage(CGImage: cgImageRef!,scale: 1.0,orientation: UIImageOrientation.Right)
                }
            })
        }
        
        
        return cell!
    }
    func collectionView(collectionView: UICollectionView!,
        layout collectionViewLayout: UICollectionViewLayout!,
        sizeForItemAtIndexPath indexPath: NSIndexPath!) -> CGSize {
            return CGSize(width: 130, height: 200)
    }
    
    
    
    
    func collectionView(collectionView: UICollectionView!,
        layout collectionViewLayout: UICollectionViewLayout!,
        insetForSectionAtIndex section: Int) -> UIEdgeInsets {
            return sectionInsets
    }
    
    //Programatically created function to segue into MapViewController
    func btn_clicked(sender: UIBarButtonItem) {
        print("Button clicked")
        presentViewController((MapViewController() as? UIViewController)!, animated: true, completion: nil)
        
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