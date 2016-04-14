//
//  GaiaUser.swift
//  Gaia
//
//  Created by Alex Clark on 4/12/16.
//  Copyright © 2016 John Henning. All rights reserved.
//

import UIKit
import Parse

class GaiaUserClient: NSObject {
    
    static let sharedInstance = GaiaUserClient()
    
    // Set instance default profile image
    func setDefaultProfileImageForUser(user: PFUser?) {
        if let user = user {
            // Default Gaia Image
            let defaultImage = UIImage(named: "Gaia iOS App")
            // Encode image using Parse into 64-bit text
            user["profilePicture"] = getPFFileUsingImage(defaultImage)
        }
        else {
            // Log Error
            log.error("Could not set default profile picture for passed user!")
        }
    }
    
    func getImageInBackgroundForCurrentUser(completion: (success: Bool?, image: UIImage?, error: NSError?) -> Void) {
        if let imageFile = PFUser.currentUser()?["profilePicture"] as? PFFile {
            imageFile.getDataInBackgroundWithBlock({ (data: NSData?, error: NSError?) ->
                Void in
                if let error = error {
                    // Send Completion
                    completion(success: false, image: nil, error: error)
                }
                else {
                    // Get image using data retrieved
                    let image = UIImage(data: data!)
                    // Send Completion
                    completion(success: true, image: image, error: nil)
                }
            })
        }
        else {
            // Cannot Return Anything
            completion(success: false, image: nil, error: nil)
        }
    
    }
    
    // Update current user's image in parse server
    func updateCapturedImageForCurrentUser(imageToSet: UIImage?, withCompletion completion: PFBooleanResultBlock?) {
        if imageToSet != nil {
            // If Current User Exists, Update His Image
            if let currentUser = PFUser.currentUser() {
                // Set the new PFFIle && Pass Completion
                currentUser["profilePicture"] = getPFFileUsingImage(imageToSet)
                currentUser.saveInBackgroundWithBlock(completion)
            }
            else {
                // Log Error
                log.error("Unable to find current user to update profile image")
            }
        }
        else {
            // Log Error
            log.error("Passed image to update for current user profile image does not exist!")
        }
    }
    
    // Convert passed image into PFFIle
    private func getPFFileUsingImage(image: UIImage?) -> PFFile? {
        // If image content exists
        if let image = image {
            // Attempt to get text rep of image
            if let data = UIImagePNGRepresentation(image) {
                // Success, able to encode and create PFFile
                return PFFile(name: "profileImage.png", data: data)
            }
            else {
                // Encoding process failed
                log.error("Unable to encode image content to PNGRepresentation")
            }
        }
        // Image content nil
        log.error("Passed image does not exist for conversion to PFFile")
        return nil
    }
}
