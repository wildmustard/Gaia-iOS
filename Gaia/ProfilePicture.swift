//
//  ProfilePicture.swift
//  Gaia
//
//  Created by Carlos Avogadro on 4/10/16.
//  Copyright © 2016 John Henning. All rights reserved.
//

import UIKit
import Parse

class ProfilePicture: NSObject {
    
    

    // Function to post the captured image to Parse Server
    func postCapturedImage(image: UIImage?,withCompletion completion: PFBooleanResultBlock?) {
        
        // Setup Parse Object
        let profilePicture = PFObject(className: "ProfilePicture")
        
        
        // Encode image using Parse into 64-bit text
        profilePicture["profilePicture"] = getPFFileUsingImage(image)
        profilePicture["username"] = PFUser.currentUser()?.username
        
        // Save capture media to server
        profilePicture.saveInBackgroundWithBlock(completion)
    }
    
    
    func getPFFileUsingImage(image: UIImage?) -> PFFile? {
        
        // If image content exists
        if let image = image {
            
            // Attempt to get text rep of image
            if let data = UIImagePNGRepresentation(image) {
                // Success, able to encode and create PFFile
                return PFFile(name: "profileImage.png", data: data)
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
        NSLog("Failure, return nil\n")
        return nil
    }
    
    
    
    
    
}
