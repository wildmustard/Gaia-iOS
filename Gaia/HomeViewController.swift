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

let userCapturedImage = "User Captured Image\n"
let userReleasedImage = "User Released Image\n"
let reloadCatalogue = "Calling Parse to Reload Images For Catalogue\n"
let reloadScores = "Calling Parse to Reload User Score Leaderboards\n"
let userSavedImage = "User Saved an Image\n"

let clarifaiClientID = "WMZrJ33oE9fISVNAPLZNVtnMhXIC9reQ9YGtAuV2"
let clarifaiClientSecret = "8lPWDBKJDIDNlnrBEiKjqnfWYlqJ8JEOGH76oseS"


class HomeViewController: UIViewController, CLLocationManagerDelegate {
    
    
    // Outlets
    @IBOutlet weak var wildLifeTagHomeView: UILabel!
    @IBOutlet weak var takenPicture: UIImageView!
    @IBOutlet weak var pictureOverlayView: UIView!
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    // Variables
    var session: AVCaptureSession!
    var stillImageOutput : AVCaptureStillImageOutput!
    var videoPreviewLayer : AVCaptureVideoPreviewLayer!
    var savedTagMatch: String!
    var userScore: PFObject?
    
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
        
        // Setup Camera Button Size, Position, Label Font-Size, Turn off Animation of Press
        cameraButton.frame = CGRectMake(160, 100, 75, 75)
        cameraButton.center = CGPointMake(parentViewController!.view.frame.width / 2, parentViewController!.view.frame.height - cameraButton.frame.height)
        cameraButton.titleLabel!.font = UIFont.systemFontOfSize(16)
        cameraButton.animateTap = false
        
        // Setup the call action for camera capture
        cameraButton.addTarget(self,  action: "onPictureTaken", forControlEvents: .TouchUpInside)
        
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        
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
        locationManager.requestWhenInUseAuthorization()
        // Add button to the subview
        self.view.addSubview(cameraButton)
        
        // Hide captured image controls and views until needed
        turnOffCapturedImageControlSettings()
        //print(myLocation.coordinate)
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
        
        //Set capture device to be back camera
        let backCamera = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        
        do{
            //Try to access back camera
            input = try AVCaptureDeviceInput(device: backCamera)
            
        } catch {
            
            // Catch Error & Nil Input
            inputError = error as NSError
            input = nil

            // Log Error
            NSLog("Could not start AVCapture: \(inputError.localizedDescription)\n")
        }
        
        // If no error occurred and there is an input device accessible, add input to current session
        if (inputError == nil && session.canAddInput(input)) {
            
            session.addInput(input)
            
            //Set output to be a jpeg
            stillImageOutput = AVCaptureStillImageOutput()
            stillImageOutput.outputSettings = [AVVideoCodecKey: AVVideoCodecJPEG]
            
            //If session accepts output
            if session.canAddOutput(stillImageOutput){

                // Add still image to output
                session.addOutput(stillImageOutput)
                
                //Set up video preview from camera into the view
                videoPreviewLayer = AVCaptureVideoPreviewLayer(session: session)
                videoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspect
                videoPreviewLayer.connection.videoOrientation = AVCaptureVideoOrientation.Portrait
                cameraView.layer.addSublayer(videoPreviewLayer)
                
                //Overlay button to eake picture on top of UIView
                cameraView.layer.addSublayer(cameraButton.layer)
                
                //Initiate session
                session.startRunning()
            
                
            }
            else {
                
                // Log error for failure to output
                NSLog("Cannot add output to session\n")
                
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
                    NSLog("Could not capture still image output async from location: \(error!.localizedDescription)\n")
                    
                }
                else { // Process the image data found in sampleBuffer in order to end up with a UIImage
                    
                    let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(sampleBuffer)
                    let dataProvider = CGDataProviderCreateWithCFData(imageData)
                    let cgImageRef = CGImageCreateWithJPEGDataProvider(dataProvider, nil, true, CGColorRenderingIntent.RenderingIntentDefault)
                    
                    //Get an UIImage
                    let image = UIImage(CGImage: cgImageRef!, scale: 1.0, orientation: UIImageOrientation.Right)
                    
                    // Set the taken image property
                    self.takenPicture.image = image
                    
                    //Clear tags & points
                    self.savedTagMatch = ""
                    self.wildLifeTagHomeView.text = ""
                    self.points = 0
                    self.myLocation = nil
                    
                    self.locationManager.requestLocation()
                    
                    // Send capture to AI server for identification
                    self.recognizeImage(image, completion: { (success, match, points, error) -> () in
                        
                        if let error = error {
                            
                            // Log error
                            NSLog("Failure recognizing image\nError: \(error)")
                            
                        }
                        else {
                            
                            if (success == true) {
                                //Set the tag retrieved
                                self.wildLifeTagHomeView.text = match
                                self.savedTagMatch = match
                                self.points = points
                                
                                

                            }
                            else {
                            
                                // Log error
                                NSLog("Couldn't recognize image content!\n")
                                self.wildLifeTagHomeView.text = "No Tag Found"
                            
                            }
                            
                            
                            // Enable controls for captured image
                            self.turnOnCapturedImageControlSettings()
                            
                        }

                    })
                    
                    // Log capture
                    NSLog("Successfully captured image\n")
                    
                }
            })
        }
        else {
            
            // Log error
            NSLog("Could not get still image output\n")
            
        }

    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.AuthorizedWhenInUse {
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            
            let latitude = location.coordinate.latitude
            let latitudeString = "\(latitude)"
            
            let longitude = location.coordinate.longitude
            let longitudeString = "\(longitude)"
            
            print(latitudeString + " " + longitudeString)
            
            self.myLocation = location
            
        }
    }
    
    
    @IBAction func onSavePhoto(sender: AnyObject) {
        
        // Log action
        NSLog("Save photo button pressed\n")
        
        //Start progressHUD
        SVProgressHUD.show()
        
        // Disable buttons until ready
        disableSaveCancelButtons()
        
        // Post captured image to the Parse Server
        capture.postCapturedImage(takenPicture.image, tag: self.savedTagMatch, points: points, location: self.myLocation, withCompletion:
            { (success: Bool, error: NSError?) -> Void in
                
                // Stop progressHUD after network task done
                SVProgressHUD.dismiss()
                
                // Check if successful post of image to server
                if let error = error {
                
                    // Log error
                    NSLog("Error posting capture image content: \(error.localizedDescription)\n")
            
                    
                    // Alert user to post failure
                    let alert = UIAlertController(title: "Error Uploading Image", message: "", preferredStyle: .Alert)
                    let dismissAction = UIAlertAction(title: "OK", style: .Default) { (action) in }
                    alert.addAction(dismissAction)
                    self.presentViewController(alert, animated: true) {}
                    
                    // Turn back on save & cancel buttons, failure to post means user may want to keep image and try again after alerted to issue
                    self.enableSaveCancelButtons()
                    
                }
                else {
                    
                    // Log success post
                    NSLog("Image capture successfully posted to parse server\n")
                    
                    
                    // Update User Score
                    self.updateScore()
                    
                    //Call functions in ScoreViewController to reload User Scores
                    NSNotificationCenter.defaultCenter().postNotificationName(reloadCatalogue, object: nil)
                    
                    // Turn off captured image controls & resume default state function
                    self.turnOffCapturedImageControlSettings()
                    
                }
            })
        
    }
    
    // Function to send the taken image to the AI for tag recognition
    private func recognizeImage(image: UIImage!, completion: (success: Bool!, match: String!,points:Int?, error: NSError?) -> ()) {
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
                completion(success: false, match: nil, points: nil,error: error)

            }
            else {
                
                // Log success of connecting to Clarifai
                NSLog("Sent Clarifai client jpeg image successfully\n")
                
                // Set tags object
                let tags = results![0].tags
                // Log tags
                NSLog("Tag content: \(results![0].tags.joinWithSeparator(", "))")
                
                // Collect the matched tag if it exists from wildlife dictionary
                let (success , match) = self.myWildlife.matchWildlife(tags)
                let points = self.myWildlife.pointsTag(match)
               
                // Set return values
                completion(success: success, match: match,points:points, error: nil)
    
                // Log status & match result
                NSLog("Match successful: \(success)\n")
                NSLog("Matched wildlife: \(match)\n")
                
                // Set image tag here
                
            }
            
        }
    }
    func updateScore() {
        
        let query = PFQuery(className: "_User").whereKey("username", equalTo: (PFUser.currentUser()?.username)!)
        
        // Query current posting user and update their score if successful
        query.getFirstObjectInBackgroundWithBlock  {
            (user: PFObject?, error: NSError?) -> Void in
            // Failure
            if error != nil {
                
                // Log Error
                log.error("Unable to retrieve current user to update score")
                
            }
            // User retrieved, update score
            else {
                
                // Update user associated score to add captured image
                user!["score"] = user!["score"] as! Int + self.points!
            
                // Log update & total
                log.debug("Updated Score of user \(PFUser.currentUser()?.username) to \(user!["score"])")
                
                // Save user object to Parse w/ completion to update leaderboard table
                user!.saveInBackgroundWithBlock({ (success: Bool?, error: NSError?) -> Void in
                    
                    // If error exists
                    if let error = error {
                        
                        // Log Error
                        log.error("Unable to save user score in background\nError: \(error)")
                        
                    }
                    // No error, update tables
                    else {
                    
                        // Log success & send out notification
                        log.debug("Saved user score in background")
                        
                        //Call functions in ScoreViewController to reload User Scores
                        NSNotificationCenter.defaultCenter().postNotificationName(reloadScores, object: nil)
                        
                    }
                })
                
            }
            
        }
        
        
    
    }
    
    
    // Cancel Button Pressed
    @IBAction func onCancelPhoto(sender: AnyObject) {
        
        // Log action
        NSLog("Cancel button pressed\n")
        
        // Turn off captured image controls
        turnOffCapturedImageControlSettings()
        self.savedTagMatch = ""
        self.wildLifeTagHomeView.text = ""
        self.points = 0
        
    }
    
    // Turn on controls & views for captured image
    func turnOnCapturedImageControlSettings() {
        
        // Show the captured image on screen
        self.takenPicture.hidden = false
        
        // Show the overlay on the image
        self.pictureOverlayView.alpha = 0.4
        self.pictureOverlayView.hidden = false
        
        // Show save and cancel buttons
        enableSaveCancelButtons()
        
        
        // Disable video and capture button
        self.cameraButton.enabled = false
        
        NSNotificationCenter.defaultCenter().postNotificationName(userCapturedImage, object: nil)
        
        // Log control state
        NSLog("Turned on image capture controls & views\n")
    
    }
    
    // Turn off controls & views for captured image
    func turnOffCapturedImageControlSettings() {
        
        takenPicture.image = nil  // Clear image
        takenPicture.hidden = true
        
        pictureOverlayView.hidden = true
        
        // Reset & hide views, save, cancel buttons
        disableSaveCancelButtons()
        
        // Enable & display camera button
        cameraButton.enabled = true
        
        NSNotificationCenter.defaultCenter().postNotificationName(userReleasedImage, object: nil)

        // Log control state
        NSLog("Turned off image capture controls & views\n")
    
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
        
        if (self.savedTagMatch != "") {
            self.saveButton.userInteractionEnabled = true
            self.saveButton.hidden = false
        }
        
        self.cancelButton.userInteractionEnabled = true
        self.cancelButton.hidden = false
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
