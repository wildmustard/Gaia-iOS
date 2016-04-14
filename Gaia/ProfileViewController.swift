//
//  ProfileViewController.swift
//  Gaia
//
//  Created by Carlos Avogadro on 4/7/16.
//  Copyright © 2016 John Henning. All rights reserved.
//

import UIKit
import Parse
import SVProgressHUD
import ZFRippleButton

let userDidLogoutNotification = "User Logged Out\n"
let userUpdatedProfileImage = "User changed Profile Image"

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    
    internal var score: Int?
    internal var capturedScore = false
    
    @IBOutlet weak var captureImageButton: UIButton!
    @IBOutlet weak var uploadButton: UIButton!
    @IBOutlet weak var imageOptionsView: UIView!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var profileUsernameLabel: UILabel!
    @IBOutlet weak var profilePictureImage: UIImageView!
    @IBOutlet weak var logoutButton: ZFRippleButton!
    
    let ivc = UIImagePickerController()
    var cachedProfileImage: UIImage?
    let tempProfileImage = UIImage(named: "Profile_Picture")


    override func viewDidLoad() {
        super.viewDidLoad()
        // Call load for user image
        loadCurrentUserProfileImage()
        // Hide current options
        hideOptions()
        // Set delegate & datasource for imageviewcontroller
        ivc.delegate = self
        ivc.allowsEditing = true
        // Setup Base Profile Info
        setupProfileUIElements()
        // Check photo library
        if (UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary) == false) {
            uploadButton.enabled = false
        }
        // Check the camera
        if (UIImagePickerController.isSourceTypeAvailable(.Camera) == false) {
            captureImageButton.enabled = false
        }
        // Listen for broadcast to update user score
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "refreshUserScore", name: reloadScores, object: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // Handle Gradient, Buttons, Label Attributes With ThemeHandler
        ThemeHandler.sharedThemeHandler.setFrameGradientTheme(self)
        ThemeHandler.sharedThemeHandler.setLargeLabelThemeAttributes(profileUsernameLabel)
        ThemeHandler.sharedThemeHandler.setLargeLabelThemeAttributes(emailLabel)
        ThemeHandler.sharedThemeHandler.setZFRippleButtonThemeAttributes(logoutButton)
        // Fix frame size on initial load
        let pvc =  self.parentViewController as! TabBarContainerViewController
        self.view.frame.size = pvc.contentView.frame.size
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Setup base info for user
    func setupProfileUIElements() {
        profilePictureImage.clipsToBounds = true;
        profileUsernameLabel.text = PFUser.currentUser()?.username
        emailLabel.text = PFUser.currentUser()?.email
        // Call score on load
        refreshUserScore()
    }
    
    // Refresh current user score
    func refreshUserScore() {
        scoreLabel.text = "\((PFUser.currentUser()!["score"] as! Int?)!)"
    }
    
    // Create rounded images for profile picture
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
        // Logout of user
        PFUser.logOutInBackgroundWithBlock { (error: NSError?) ->
            Void in
            if let error = error {
                // Log Error Logging Out
                log.error("Error on logout:\n\(error.localizedDescription)")
            }
            else {
                // Log Success
                log.info("Logout Success")
                // Broadcast Logout Event to App
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
        // Show progress wheel
        SVProgressHUD.show()
        // Bring up everything we need for picker
        let editedImage = info[UIImagePickerControllerEditedImage] as! UIImage
        // Set current user image
        GaiaUserClient.sharedInstance.updateCapturedImageForCurrentUser(editedImage, withCompletion: { (success, error) ->
            Void in
                if let error = error {
                    // Log Error
                    log.error("Unable to update current user profile image\nError: \(error.localizedDescription)")
                }
                else {
                    // Log Success
                    log.info("Successfully updated current user profile image")
                    // Set new cached image
                    self.cachedProfileImage = editedImage
                    // Set image regardless, will default back to old image if save was unsuccessful
                    self.profilePictureImage.image = self.roundImage(editedImage)
                    // Broadcast that user updated profile picture
                    NSNotificationCenter.defaultCenter().postNotificationName(userUpdatedProfileImage, object: nil)
                }
            // Dismiss Progress Wheel
            SVProgressHUD.dismiss()
        })
        // Dismiss controller
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func hideOptions() {
    
        captureImageButton.hidden = true
        uploadButton.hidden = true
        imageOptionsView.hidden = true
    
    
    }
    func displayOptions() {
        
        captureImageButton.hidden = false
        uploadButton.hidden = false
        imageOptionsView.hidden = false
    
    }
    
    // Set default image & load current user image in background
    func loadCurrentUserProfileImage() {
        if let cachedProfileImage = cachedProfileImage {
            // Used cached image as profile picture
            profilePictureImage.image = roundImage(cachedProfileImage)
        }
        else {
            // Set Temp While Load
            profilePictureImage.image = tempProfileImage
            // Attempt to gather background data from current user
            GaiaUserClient.sharedInstance.getImageInBackgroundForCurrentUser( { (success, image, error) -> () in
                if let error = error {
                    // Log Error from Downloading
                    log.error("Failure to get current user profile image in background\nError: \(error.localizedDescription)")
                }
                else {
                    if (success == true) {
                        // Log
                        log.info("Loaded & set current user profile image")
                        // Set Loaded Image
                        self.profilePictureImage.image = self.roundImage(image!)
                        self.cachedProfileImage = image
                    }
                    else {
                        // Log Failure To Find PFFile on Current User
                        log.error("Failure to find profile picture PFFile on current user")
                    }
                }
            })
        }
    }
}
