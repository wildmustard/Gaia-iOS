//
//  CaptureMedia.swift
//  Gaia
//
//  Created by Alex Clark on 3/17/16.
//  Copyright © 2016 John Henning. All rights reserved.
//

import UIKit
import Parse

// Class for the content of the captured image
class CaptureMedia: NSObject {
    var totalPoints:Int = 0
    
    // Function to post the captured image to Parse Server
    func postCapturedImage(image: UIImage?, tag: String?, points: Int?, location: CLLocation?, withCompletion completion: PFBooleanResultBlock?) {
        
        // Setup Parse Object
        let capture = PFObject(className: "CaptureMedia")
        
        
        // Encode image using Parse into 64-bit text
        capture["image"] = getPFFileUsingImage(image)
        capture["username"] = PFUser.currentUser()?.username
        capture["tag"] = tag
        capture["points"] = points
        capture["location"] = location
        
        
        // Save capture media to server
        capture.saveInBackgroundWithBlock(completion)
    }
    
    
    func getPFFileUsingImage(image: UIImage?) -> PFFile? {
        
        // If image content exists
        if let image = image {
        
            // Attempt to get text rep of image
            if let data = UIImagePNGRepresentation(image) {
                // Success, able to encode and create PFFile
                return PFFile(name: "capture.png", data: data)
            }
            else {
                
                // Encoding process failed
                NSLog("Unable to encode image content to text rep\n")
            }
        }
        else {
            
            // Image content nil
            NSLog("No image content received\n")
            
        }
        
        // Failure, return nil
        return nil
    }
    
            
        
        
    
}
