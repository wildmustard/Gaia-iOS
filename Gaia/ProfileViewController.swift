//
//  ProfileViewController.swift
//  Gaia
//
//  Created by Carlos Avogadro on 4/7/16.
//  Copyright © 2016 John Henning. All rights reserved.
//

import UIKit
import Parse

let userDidLogoutNotification = "User Logged Out\n"

class ProfileViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate  {
    
    internal var score: Int?
    internal var capturedScore = false
    
    
    @IBOutlet weak var captureImageButton: UIButton!
    @IBOutlet weak var uploadButton: UIButton!
    @IBOutlet weak var imageOptionsView: UIView!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var profileUsernameLabel: UILabel!
    @IBOutlet weak var profilePictureImage: UIImageView!
    
    let ivc = UIImagePickerController()
    
    var userImage: PFFile?
    
    var profilePcture: UIImage?


    override func viewDidLoad() {
        super.viewDidLoad()
        hideOptions()
        
        loadImages()
        
        ivc.delegate = self
        ivc.allowsEditing = true
        
        let profileImage = UIImage(named: "Profile_Picture")
        
        
        //profileImageView = UIImageView(image: profileImage)
        
        //profilePictureImage.image = roundImage(profileImage!)
        
        PFUser.currentUser()
        //self.profilePictureImage.layer.cornerRadius = self.profilePictureImage.frame.size.width / 2;
        self.profilePictureImage.clipsToBounds = true;
        
        profileUsernameLabel.text = PFUser.currentUser()?.username
        
        scoreLabel.text = "\((PFUser.currentUser()!["score"] as! Int?)!)"
        
        emailLabel.text = PFUser.currentUser()?.email
        
        // Check photo library
        if (UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary) == false) {
            uploadButton.enabled = false
        }
        
        // Check the camera
        if (UIImagePickerController.isSourceTypeAvailable(.Camera) == false) {
            captureImageButton.enabled = false
        }

    

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //Create rounded images
    func roundImage (image:UIImage) -> UIImage {
        
        let size = CGSizeMake(640, 640)
        UIGraphicsBeginImageContext(size)
        let ctx = UIGraphicsGetCurrentContext()
        CGContextAddArc(ctx, 320, 320, 320,0.0, CGFloat(2 * M_PI), 1)
        CGContextClip(ctx)
        CGContextSaveGState(ctx)
        CGContextTranslateCTM(ctx, 0.0, 640)
        CGContextScaleCTM(ctx, 1.0, -1)
        CGContextDrawImage(ctx, CGRectMake(0, 0, 640, 640), image.CGImage)
        CGContextRestoreGState(ctx)
        let finalImage = UIGraphicsGetImageFromCurrentImageContext()
        
        
        UIGraphicsEndImageContext()
        return finalImage
        
    }

    @IBAction func onLogout(sender: AnyObject) {
        
        PFUser.logOutInBackgroundWithBlock { (error: NSError?) ->
            Void in
            
            if let error = error {
                // Log
                NSLog("Error on logout:\n\(error.localizedDescription)")
            }
            else {
                
                // Log
                NSLog("Logout Success")
                //Broadcast
                NSNotificationCenter.defaultCenter().postNotificationName(userDidLogoutNotification, object: nil)
                
            }
            
        }

    }
    @IBAction func onAddImage(sender: AnyObject) {
        displayOptions()
        
    }
    @IBAction func onTap(sender: AnyObject) {
        hideOptions()
        
    }
    @IBAction func onUpload(sender: AnyObject) {
        
        // Bring up the photo lib
        ivc.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        
        // Enable the hidden media fields
        showImagePickerController()
        
    }
    @IBAction func onCaptureImage(sender: AnyObject) {
        
        // Bring up the camera
        ivc.sourceType = UIImagePickerControllerSourceType.Camera
        
        showImagePickerController()
    }
    
    // Show the ivc
    func showImagePickerController() {
        self.presentViewController(ivc, animated: true, completion: nil)
    }
    
    // Setup the image picker controller
    func imagePickerController(picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        // Bring up everything we need for picker
        
        
        
        let editedImage = info[UIImagePickerControllerEditedImage] as! UIImage
        
        // Set image
        profilePictureImage.image = roundImage(editedImage)
        
        // Dismiss controller
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func hideOptions(){
    
        captureImageButton.hidden = true
        uploadButton.hidden = true
        imageOptionsView.hidden = true
    
    
    }
    func displayOptions(){
        captureImageButton.hidden = false
        uploadButton.hidden = false
        imageOptionsView.hidden = false
    
    }
    
    func loadImages()
    {
        let query = PFQuery(className: "ProfilePicture").whereKey("username", equalTo: (PFUser.currentUser()?.username)!)
        
        query.findObjectsInBackgroundWithBlock { (content: [PFObject]?, error: NSError?) ->
            Void in
            if (error != nil) {
                let userData:PFObject = (content! as NSArray).lastObject as! PFObject
                
               self.userImage = userData["profilePicture"] as! PFFile?
                
                self.userImage!.getDataInBackgroundWithBlock({ (data: NSData?, error: NSError?) ->
                    Void in
                    
                    
                    // Failure to get image
                    if let error = error {
                        
                        // Log Failure
                        NSLog("Unable to get image data Error: \(error)")
                        
                    }
                        // Success getting image
                    else {
                        
                        // Get image and set to cell's content
                        let image = UIImage(data: data!)
                        
                        self.profilePcture = image
                        
                        self.profilePictureImage.image = self.roundImage(self.profilePcture!)
                    }


            
                })
            }
            
            
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

}
