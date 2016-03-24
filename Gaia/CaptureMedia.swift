//
//  CaptureMedia.swift
//  Gaia
//
//  Created by Alex Clark on 3/17/16.
//  Copyright © 2016 John Henning. All rights reserved.
//

import UIKit
import Parse

let clarifaiClientID = "WMZrJ33oE9fISVNAPLZNVtnMhXIC9reQ9YGtAuV2"
let clarifaiClientSecret = "8lPWDBKJDIDNlnrBEiKjqnfWYlqJ8JEOGH76oseS"

// Class for the content of the captured image
class CaptureMedia: NSObject {
    var myWildlife: Wildlife
    private lazy var client : ClarifaiClient = ClarifaiClient(appID: clarifaiClientID, appSecret: clarifaiClientSecret)
    
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
    func recognizeImage(image: UIImage!) {
        // Scale down the image. This step is optional. However, sending large images over the
        // network is slow and does not significantly improve recognition performance.
        let size = CGSizeMake(320, 320 * image.size.height / image.size.width)
        UIGraphicsBeginImageContext(size)
        image.drawInRect(CGRectMake(0, 0, size.width, size.height))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // Encode as a JPEG.
        let jpeg = UIImageJPEGRepresentation(scaledImage, 0.9)!
        
        // Send the JPEG to Clarifai for standard image tagging.
        client.recognizeJpegs([jpeg]) {
            (results: [ClarifaiResult]?, error: NSError?) in
            if (error != nil) {
                NSLog("Unable to send Clarifai client jpeg image\nError: \(error)\n")
                //self.textView.text = "Sorry, there was an error recognizing your image."
            }
            else {
              //  self.textView.text = "Tags:\n" + results![0].tags.joinWithSeparator(", ")
                NSLog("Sent Clarifai client jpeg image successfully\n")
                let tags = results![0].tags
                var wild = myWildlife.getWildlife()
                NSLog("Tag content: \(results![0].tags.joinWithSeparator(", "))")
                
                var match = ""
                for tag in tags {
                    for wildlife in wild {
                        if (tag == wildlife) {
                            match = tag
                            break
                        }
                    }
                    if (match != "") {
                        break
                    }
                }
            }
            //self.button.enabled = true
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
