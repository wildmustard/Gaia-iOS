//
//  HomeViewController.swift
//  Gaia
//
//  Created by Alex Clark on 3/8/16.
//  Copyright © 2016 John Henning. All rights reserved.
//

import UIKit
import AVFoundation
import DKCircleButton
import SVProgressHUD
import Parse
import CoreLocation
import ZFRippleButton

let userCapturedImage = "User Captured Image\n"
let userReleasedImage = "User Released Image\n"
let reloadCatalogue = "Calling Parse to Reload Images For Catalogue\n"
let reloadScores = "Calling Parse to Reload User Score Leaderboards\n"
let userSavedImage = "User Saved an Image\n"

let clarifaiClientID = "WMZrJ33oE9fISVNAPLZNVtnMhXIC9reQ9YGtAuV2"
let clarifaiClientSecret = "8lPWDBKJDIDNlnrBEiKjqnfWYlqJ8JEOGH76oseS"


class HomeViewController: UIViewController, CLLocationManagerDelegate {
    
    
    // Outlets
    @IBOutlet weak var takenPicture: UIImageView!
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var saveButton: ZFRippleButton!
    @IBOutlet weak var cancelButton: ZFRippleButton!
    @IBOutlet weak var errorMessageLabel: UILabel!
    @IBOutlet weak var tagPreviewLabel: UILabel!
    @IBOutlet weak var tagListButton: ZFRippleButton!
    @IBOutlet weak var tagListView: UIScrollView!
    @IBOutlet weak var tagListLabel: UILabel!
    
    // Variables
    var session: AVCaptureSession!
    var stillImageOutput : AVCaptureStillImageOutput!
    var videoPreviewLayer : AVCaptureVideoPreviewLayer!
    var savedTagMatch: String!
    var savedTagsList: String!
    var userScore: PFObject?
    var wildlife: [PFObject]?
    var savedWildlifeURL: String?
    
    var saved = false
    var tagListOpen = false
    var locationManager = CLLocationManager()
    var myLocation: CLLocation!
    
    // CaptureMedia Object instance to submit to server
    let capture = CaptureMedia()
    // Wildlife Dictionary
    let myWildlife = Wildlife()
    //ImageCatalogue functions
    let imageCatalogue = ImageCatalogueViewController()
    // Clarifai Session
    private lazy var client : ClarifaiClient = ClarifaiClient(appID: clarifaiClientID, appSecret: clarifaiClientSecret)
    // Camera Button
    let cameraButton = DKCircleButton.init(type: .Custom) // Capture Button for Camera using DK Pod
    //Points for image
    var points:Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        queryWildlife()
        
        
        // Setup Camera Button Size, Position, Label Font-Size, Turn off Animation of Press
        cameraButton.frame = CGRectMake(160, 100, 75, 75)
        cameraButton.center = CGPointMake(parentViewController!.view.frame.width / 2, parentViewController!.view.frame.height - cameraButton.frame.height)
        cameraButton.titleLabel!.font = UIFont.systemFontOfSize(16)
        cameraButton.animateTap = false
        
        // Setup the call action for camera capture
        cameraButton.addTarget(self,  action: "onPictureTaken", forControlEvents: .TouchUpInside)
        
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            print("Location Successful")
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        } else {
            print("No location")
        }
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.distanceFilter = 200

        // Add button to the subview
        self.view.addSubview(cameraButton)
        
        // Hide captured image controls and views until needed
        turnOffCapturedImageControlSettings()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        //Resize preview layer
        if videoPreviewLayer != nil {
            videoPreviewLayer.frame = cameraView.bounds
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        
        // Setup Session Var for AVCapture
        session = AVCaptureSession()
        session.sessionPreset = AVCaptureSessionPresetHigh
        
        // Instantiate vars for error and input
        var inputError: NSError!
        var input: AVCaptureDeviceInput!
        
        // Set capture device to be back camera
        let backCamera = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        
        // Setup Theme UI
        ThemeHandler.sharedThemeHandler.setZFRippleButtonThemeAttributes(saveButton)
        ThemeHandler.sharedThemeHandler.setZFRippleButtonThemeAttributes(cancelButton)
        ThemeHandler.sharedThemeHandler.setToggleZFRippleButtonThemeAttributes(tagListButton)
        ThemeHandler.sharedThemeHandler.setSmallLabelThemeAttributes(errorMessageLabel)
        ThemeHandler.sharedThemeHandler.setLabelThemeAttributes(tagListLabel)
        saveButton.backgroundColor = ThemeHandler.sharedThemeHandler.PrimaryColor3
        errorMessageLabel.hidden = true
        // Scrollview Content Size
        tagListView.contentSize = CGSize(width: tagListView.frame.size.width, height: tagListLabel.frame.origin.y + tagListLabel.frame.size.height)
        
        
        do {
            // Try to access back camera
            input = try AVCaptureDeviceInput(device: backCamera)    
        }
        catch {
            
            // Catch Error & Nil Input
            inputError = error as NSError
            input = nil

            // Log Error
            log.error("Could not start AVCapture: \(inputError.localizedDescription)\n")
        }
        
        // If no error occurred and there is an input device accessible, add input to current session
        if (inputError == nil && session.canAddInput(input)) {
            
            session.addInput(input)
            
            // Set output to be a jpeg
            stillImageOutput = AVCaptureStillImageOutput()
            stillImageOutput.outputSettings = [AVVideoCodecKey: AVVideoCodecJPEG]
            
            // If session accepts output
            if session.canAddOutput(stillImageOutput){

                // Add still image to output
                session.addOutput(stillImageOutput)
                
                // Set up video preview from camera into the view
                videoPreviewLayer = AVCaptureVideoPreviewLayer(session: session)
                videoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspect
                videoPreviewLayer.connection.videoOrientation = AVCaptureVideoOrientation.Portrait
                cameraView.layer.addSublayer(videoPreviewLayer)
                
                // Overlay button to eake picture on top of UIView
                cameraView.layer.addSublayer(cameraButton.layer)
                
                // Initiate session
                session.startRunning()
            
                
            }
            else {
                
                // Log error for failure to output
                log.error("Cannot add output to session\n")
                
            }
        }
      }
    
    //Tap action to take a picture
    func onPictureTaken() {
        //Get the connection from the stillImageOutput
        if (stillImageOutput != nil) {
            let videoConnection = stillImageOutput.connectionWithMediaType(AVMediaTypeVideo)
            stillImageOutput.captureStillImageAsynchronouslyFromConnection(videoConnection, completionHandler: { (sampleBuffer, error) -> Void in
                
                if (error != nil) {
                    
                    // Log Error
                    log.error("Could not capture still image output async from location: \(error!.localizedDescription)\n")
                    
                }
                else { // Process the image data found in sampleBuffer in order to end up with a UIImage
                    
                    let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(sampleBuffer)
                    let dataProvider = CGDataProviderCreateWithCFData(imageData)
                    let cgImageRef = CGImageCreateWithJPEGDataProvider(dataProvider, nil, true, CGColorRenderingIntent.RenderingIntentDefault)
                    
                    //Get an UIImage
                    let image = UIImage(CGImage: cgImageRef!, scale: 1.0, orientation: UIImageOrientation.Right)
                    
                    // Set the taken image property
                    self.takenPicture.image = image
                    
                    // Prevent camera button from being pressed until we have been told if image contained a tag
                    self.cameraButton.userInteractionEnabled = false
                    
                    // Send capture to AI server for identification
                    self.recognizeImage(image, completion: { (success, match, tags, points, url, error) -> () in
                        
                        if let error = error {
                            
                            // Log error
                            log.error("Failure recognizing image\nError: \(error)")
                            
                        }
                        else {
                            
                            if (success == true) {
                                
                                //Clear tags & points
                                self.savedTagMatch = ""
                                self.tagPreviewLabel.text = ""
                                self.points = 0
                                self.myLocation = nil
                                
                                self.locationManager.requestLocation()
                                
                                //Set the tag retrieved
                                self.savedTagMatch = match.capitalizedString
                                self.tagPreviewLabel.text = self.savedTagMatch
                                self.savedTagsList = tags.joinWithSeparator(", ").capitalizedString
                                self.tagListLabel.text = self.savedTagsList
                                
                                self.points = points
                                self.savedWildlifeURL = url
                                
                                // Enable controls for captured image
                                self.turnOnCapturedImageControlSettings()

                            }
                            else {
                            
                                // Log error
                                log.error("Couldn't recognize image content!\n")
                                
                                // Captured picture was unable to be identified, inform the user and try again!
                                self.showDelayedErrorMessage()
                            
                            }
                            
                            // Re-enable camera button to be pressed
                            self.cameraButton.userInteractionEnabled = true
                            
                        }

                    })
                    
                    // Log capture
                    log.debug("Successfully captured image\n")

                }
            })
        }
        else {
            
            // Log error
            log.error("Could not get still image output\n")
            
        }

    }
    
    
    // Display the error message for being unable to find a tag
    func showDelayedErrorMessage() {
        
        // Show Error Message Label
        
        errorMessageLabel.hidden = false
        
        // Hide Error Message Label After Delay
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(2 * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), {
                self.errorMessageLabel.hidden = true
        })
        
    }
    
    func queryWildlife(){
        let query = PFQuery(className: "Wildlife")
        
        query.orderByDescending("name")
        
        query.cachePolicy = .CacheThenNetwork
        
        query.findObjectsInBackgroundWithBlock { (content: [PFObject]?, error: NSError?) ->
            Void in
            // If we are able to get new userMedia, then set out new media as the new userMedia object
            if let content = content {
                
                // Reset user media object for the tableview data, reload table to display it
                NSLog("Queried data successfully")
                
                //                for each in content {
                //                    print("\(each["tag"])")
                //                }
                
                self.wildlife = content
                
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
    
    
    // Location Manager for recording position of capture from image
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.AuthorizedWhenInUse {
            
        }
    }

    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        // Check if locations if new
        if let location = locations.first {
            
            // Grab long. & lat. of position for first gathered location
            let latitude = location.coordinate.latitude
            let latitudeString = "\(latitude)"
            let longitude = location.coordinate.longitude
            let longitudeString = "\(longitude)"

            // Log coordinates
            log.debug(latitudeString + " " + longitudeString)
            
            // Update location
            self.myLocation = location
            
            // If was saved, then add the location to the image
            if self.saved {
                postImage()
                self.saved = false
            }
            
        }
    }
    
    // Location Manager Failure Clause
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        
        // Log Error for failure of location manager
        log.error("Location manager failure!\nError:\(error.localizedDescription)")
        
    }
    
    // Post image to server
    func postImage() {
        capture.postCapturedImage(takenPicture.image, tag: self.savedTagMatch, tagsList: self.savedTagsList, points: points, location: self.myLocation, url: self.savedWildlifeURL, withCompletion:
            { (success: Bool, error: NSError?) -> Void in
                
                // Check if successful post of image to server
                if let error = error {
                    
                    // Log error
                    log.error("Error posting capture image content: \(error.localizedDescription)\n")
                    
                    
                    // Alert user to post failure
                    let alert = UIAlertController(title: "Error Uploading Image", message: "Please try again", preferredStyle: .Alert)
                    let dismissAction = UIAlertAction(title: "OK", style: .Default) { (action) in }
                    alert.addAction(dismissAction)
                    self.presentViewController(alert, animated: true) {}
                    
                    // Turn back on save & cancel buttons, failure to post means user may want to keep image and try again after alerted to issue
                    self.enableSaveCancelButtons()
                    self.enableTagListButton()
                    
                }
                else {
                    
                    // Log success post
                    log.debug("Image capture successfully posted to parse server\n")
                    
                    // Update User Score
                    self.updateCurrentUserScore()
                    
                    //Call functions in ScoreViewController to reload User Scores
                    NSNotificationCenter.defaultCenter().postNotificationName(reloadCatalogue, object: nil)
                    
                    // Turn off captured image controls & resume default state function
                    self.turnOffCapturedImageControlSettings()
                    
                }
                
                // Finally dismiss HUD regardless of sucesss or fail here after process is completed
                SVProgressHUD.dismiss()
        })
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    @IBAction func onSavePhoto(sender: AnyObject) {
        
        // Log action
        log.debug("Save photo button pressed\n")
        
        //Start progressHUD
        SVProgressHUD.show()
        
        // Disable buttons until ready
        disableSaveCancelButtons()
        disableTagListButton()
        
        if self.myLocation != nil {
        
            // Log Saved
            log.debug("Saved image location on post")
            postImage()
            
        }
        else {
            
            // Log Failure
            log.debug("Failure to use location on save of image")
            self.saved = true
            
        }
        
        
    }
    
    
    // Handle displaying the tag list of the picture
    @IBAction func onTagPress(sender: AnyObject) {
        
        // Close / Open List based on state
        if (tagListOpen) {
        
            // Hide the view
            tagListView.hidden = true
            tagListOpen = false
            toggleTagButtonImage()
            
        }
        else {
            
            // Display the view
            tagListView.hidden = false
            tagListOpen = true
            toggleTagButtonImage()
        
        }
    }
    
    
    // Function to send the taken image to the AI for tag recognition
    private func recognizeImage(image: UIImage!, completion: (success: Bool!, match: String!, tags: [String]!, points:Int?, url: String!, error: NSError?) -> ()) {
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
                
                // Log failure to connect
                NSLog("Unable to send Clarifai client jpeg image\nError: \(error)\n")
                completion(success: false, match: nil, tags: [], points: nil, url: nil, error: error)

            }
            else {
                
                // Log success of connecting to Clarifai
                log.debug("Sent Clarifai client jpeg image successfully\n")
                
                // Set tags object
                let tags = results![0].tags
                // Log tags
                log.debug("Tag content: \(results![0].tags.joinWithSeparator(", "))")
                
                // Collect the matched tag if it exists from wildlife dictionary
                let (success , match) = self.myWildlife.matchWildlife(tags,wildlife: self.wildlife!)
                let name = match["name"] as? String
                let points = match["score"] as? Int
                let url = match["wiki"] as? String
                
                // Set return values
                completion(success: success, match: name, tags: tags, points:points, url: url, error: nil)
                
                // Log status & match result
                log.debug("Match successful: \(success)\n")
                log.debug("Matched wildlife: \(match)\n")
                
            }
            
        }
    }
    
    func updateCurrentUserScore() {
        // Check if current user exists
        let currentUser = PFUser.currentUser()
        // Save temp score in case fail
        let tempScore = currentUser!["score"] as! Int
        // Increment Score
        currentUser!["score"] = tempScore + points!
        // Save current user
        currentUser!.saveInBackgroundWithBlock({ (success, error) -> Void in
            if let error = error {
                // Revert Score
                currentUser!["score"] = tempScore
                // Log Error
                log.error("Unable to save current user to update score\nError: \(error.localizedDescription)")
            }
            else {
                // Log update & total
                log.debug("Updated score of current user \(currentUser!.username!) to \(currentUser!["score"])")
                // Log success & send out notification
                log.debug("Saved user score in background")
                // Call functions in ScoreViewController to reload User Scores
                NSNotificationCenter.defaultCenter().postNotificationName(reloadScores, object: nil)
            }
        })
    }
    
    
    // Cancel Button Pressed
    @IBAction func onCancelPhoto(sender: AnyObject) {
        // Log action
        log.debug("Cancel button pressed\n")
        // Turn off captured image controls
        turnOffCapturedImageControlSettings()
        // Clear default values
        self.savedTagMatch = ""
        self.tagPreviewLabel.text = ""
        self.points = 0
    }
    
    // Turn on controls & views for captured image
    func turnOnCapturedImageControlSettings() {
        
        // Show the captured image on screen
        self.takenPicture.hidden = false
        self.tagPreviewLabel.hidden = false
        
        // Show save and cancel buttons
        enableSaveCancelButtons()
        enableTagListButton()
        
        // Disable video and capture button
        self.cameraButton.enabled = false
        
        // Broadcast that user has taken a picture and that the scrollview needs to be locked
        NSNotificationCenter.defaultCenter().postNotificationName(userCapturedImage, object: nil)
        
        // Log control state
        log.debug("Turned on image capture controls & views\n")
    
    }
    
    // Turn off controls & views for captured image
    func turnOffCapturedImageControlSettings() {
        
        takenPicture.image = nil  // Clear image
        takenPicture.hidden = true
        tagPreviewLabel.hidden = true
        tagListView.hidden = true
        
        // Reset & hide views, save, cancel, tag buttons
        disableSaveCancelButtons()
        disableTagListButton()
        
        // Enable & display camera button
        cameraButton.enabled = true
        
        // Broadcast that user has released the image and scrollview can continue scrolling
        NSNotificationCenter.defaultCenter().postNotificationName(userReleasedImage, object: nil)

        // Log control state
        log.debug("Turned off image capture controls & views\n")
    
    }
    
    
    // Turn off cancel save buttons
    func disableSaveCancelButtons() {
        saveButton.userInteractionEnabled = false
        cancelButton.userInteractionEnabled = false
        cancelButton.hidden = true
        saveButton.hidden = true
    }
    
    // Turn on cancel save buttons
    func enableSaveCancelButtons() {
        saveButton.userInteractionEnabled = true
        saveButton.hidden = false
        cancelButton.userInteractionEnabled = true
        cancelButton.hidden = false
    }
    
    func disableTagListButton() {
        tagListOpen = false
        tagListButton.userInteractionEnabled = false
        tagListButton.hidden = true
        toggleTagButtonImage()
    }
    
    func enableTagListButton() {
        tagListButton.userInteractionEnabled = true
        tagListButton.hidden = false
        toggleTagButtonImage()
    }
    
    func toggleTagButtonImage() {
        if (tagListOpen) {
            // Toggle tag button color
            tagListButton.setImage(UIImage(named: "ic_loyalty_white_enabled_36pt"), forState: .Normal)
        }
        else {
            // Reset tag button image
            tagListButton.setImage(UIImage(named: "ic_loyalty_white_36pt"), forState: .Normal)
        }
    }

}
