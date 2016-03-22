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

    // Function to post the captured image to Parse Server
    func postCapturedImage(image: UIImage?, withCompletion completion: PFBooleanResultBlock?) {
    
        // Setup Parse Object
        let capture = PFObject(className: "CaptureMedia")
        
        // Encode image using Parse into 64-bit text
        capture["image"] = getPFFileUsingImage(image)
        capture["username"] = "Gaia Dummy User"
        
        // Save capture media to server
        capture.saveInBackgroundWithBlock(completion)
    }
    
    // Function to send the taken image to the AI for tag recognition
    func postImageToAI(image: UIImage?, withCompletion completion: PFBooleanResultBlock?) {
        
        // Test if image exists
        if (image != nil) {
            
            // Set image as png representation for 64bit encode
            let imageNsData = UIImagePNGRepresentation(image!)
            let base64String = imageNsData!.base64EncodedStringWithOptions(.Encoding64CharacterLineLength)
            
            // Create object for the base64 encode of the image to send to server
            let imageDic = ["base64":base64String] as NSDictionary
            
            // Create jsonData
            var jsonData: NSData!
            
            do {
            
            // Create json data serialization of imageDic, output it as object notation w/ writing options
            jsonData = try NSJSONSerialization.dataWithJSONObject(imageDic, options: NSJSONWritingOptions.PrettyPrinted)
                
            } catch let error as NSError? {
                
                // Log serialization error
                NSLog("Failed to serialize jsonData\nError: \(error)")
                
            }
            
            // Post the jsonData from the imageDic to the server to be read
//            POST("https://radiant-coast-25783.herokuapp.com/gaia/api/v1.0/imagePOST", parameters: jsonData, success: { (operation: NSURLSessionDataTask, response: AnyObject?) -> Void in
//                    
//                    // Log success of jsonData submission
//                    NSLog("Successfully sent jsonData to server\n")
//                    
//                })
//                // Error handling
//                { (operation: NSURLSessionDataTask?, error: NSError) -> Void in
//                
//                    // Log failure for attempting to submit the jsonData
//                    NSLog("Failed to send jsonData to server\nError: \(error)")
//                
//                }
//            }
//            else {
//        
//                // Log failure due to nil image
//                NSLog("Failed to read image on attempt to postImageToAI\n")
//            
//            }
    
    }
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
