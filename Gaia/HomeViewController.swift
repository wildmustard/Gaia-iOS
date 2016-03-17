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

class HomeViewController: UIViewController {
    
    
    // Outlets
    @IBOutlet weak var takenPicture: UIImageView!
    @IBOutlet weak var pictureOverlayView: UIView!
    @IBOutlet weak var cameraView: UIView!
    
    
    // Variables
    let cameraButton = DKCircleButton.init(type: .Custom) // Capture Button for Camera using DK Pod
    var session: AVCaptureSession!
    var stillImageOutput : AVCaptureStillImageOutput!
    var videoPreviewLayer : AVCaptureVideoPreviewLayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup Camera Button Size, Position, Label Font-Size, Turn off Animation of Press
        cameraButton.frame = CGRectMake(160, 100, 75, 75)
        cameraButton.center = CGPointMake(160, 510)
        cameraButton.titleLabel!.font = UIFont.systemFontOfSize(16)
        cameraButton.animateTap = false
        
        // Setup the call action for camera capture
        cameraButton.addTarget(self,  action: "onPictureTaken", forControlEvents: .TouchUpInside)
        
        // Add button to the subview
        self.view.addSubview(cameraButton)
        
        // Hide overlay and view for captured image unless there is a set image
        pictureOverlayView.hidden = true
        takenPicture.hidden = true
        
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
                session!.startRunning()
                
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
        if let videoConnection = stillImageOutput?.connectionWithMediaType(AVMediaTypeVideo){
            
            stillImageOutput?.captureStillImageAsynchronouslyFromConnection(videoConnection, completionHandler: { (sampleBuffer, error) -> Void in
                
                if (error != nil) {
                    
                    // Log Error
                    NSLog("Could not get still image output: \(error!.localizedDescription)")
                    
                }
                else { // Process the image data found in sampleBuffer in order to end up with a UIImage
                    
                    let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(sampleBuffer)
                    let dataProvider = CGDataProviderCreateWithCFData(imageData)
                    let cgImageRef = CGImageCreateWithJPEGDataProvider(dataProvider, nil, true, CGColorRenderingIntent.RenderingIntentDefault)
                    
                    //Get an UIImage
                    let image = UIImage(CGImage: cgImageRef!,scale: 1.0,orientation: UIImageOrientation.Right)
                    
                    // Show the captured image on screen
                    self.takenPicture.image = image
                    self.takenPicture.hidden = false
                    
                    // Show the overlay on the image
                    self.pictureOverlayView.alpha = 0.4
                    self.pictureOverlayView.hidden = false
                    
                    // Log capture
                    NSLog("Successfully captured image\n")
                }
            })
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
