//
//  ImageCatalogueViewController.swift
//  Gaia
//
//  Created by Alex Clark on 3/8/16.
//  Copyright © 2016 John Henning. All rights reserved.
//

import UIKit

class ImageCatalogueViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    
    @IBOutlet var CatalogueCollectionView: UICollectionView!
    var myImage = UIImage(named: "Apple_Swift_Logo")

    
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
    // func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // 1
        // Return the number of sections
     //   return 1
   // }
    
    
     func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // 2
        // Return the number of items in the section
        return 100
    }
    
     func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        // 3
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MyCell", forIndexPath: indexPath) as? CustomCellCollectionViewCell
        
        // Configure the cell
       // cell?.backgroundColor =  UIColor(red: 1, green: 165/255, blue: 0, alpha: 1)
        cell?.cellImageView.image = myImage
        
        
        return cell!
    }
    

}


