//
//  Media.swift
//  Gaia
//
//  Created by Alex Clark on 3/30/16.
//  Copyright © 2016 John Henning. All rights reserved.
//

import UIKit
import Parse

class Media: NSObject {
    
    var image: UIImage?
    var content: PFObject?
    
    init(content: PFObject) {
        
        super.init()
    
        // Set data
        self.content = content
        self.image = nil
        
        if let imageFile = content["image"] {
        
            imageFile.getDataInBackgroundWithBlock({ (data: NSData?, error: NSError?) ->
                Void in
                
                // Failure to get image
                if let error = error {
                    
                    // Log Failure
                    NSLog("Unable to get image data for media\nError: \(error)")
                    
                }
                    // Success getting image
                else {
                    
                    // Get image and set to cell's content
                    let imgFromData = UIImage(data: data!)
                    self.image = UIImage(CGImage: (imgFromData?.CGImage)!,scale: 1.0,orientation: UIImageOrientation.Right)
                    
                }
            })
            
            
        }
        
    }
    
    // Return media array from the inputted data
    class func mediaWithArray(array: [PFObject]) -> [Media] {
        var media = [Media]()
        
        for content in array {
            media.append(Media(content: content))
        }
        
        return media
    }
    
    
}
