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
    
    @IBOutlet weak var takenPicture: UIImageView!
    @IBOutlet weak var pictureDisplayView: UIView!
    //Outlet for camera preview
    @IBOutlet weak var cameraView: UIView!
    
    let cameraButton = DKCircleButton.init(type: .Custom)
    var session: AVCaptureSession?
    var stillImageOutput : AVCaptureStillImageOutput?
    var videoPreviewLayer : AVCaptureVideoPreviewLayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Setup Camera Button

        cameraButton.frame = CGRectMake(160, 100, 75, 75)
        cameraButton.center = CGPointMake(160, 510)
        cameraButton.titleLabel!.font = UIFont.systemFontOfSize(16)
        cameraButton.addTarget(self,  action: "onPictureTaken", forControlEvents: .TouchUpInside)
        cameraButton.animateTap = false
        self.view.addSubview(cameraButton)
        
        //Set up picture views
        pictureDisplayView.hidden = true
        takenPicture.hidden = true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        //Resize preview layer
        videoPreviewLayer?.frame = cameraView.bounds
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        session = AVCaptureSession()
        session!.sessionPreset = AVCaptureSessionPresetHigh
        var error: NSError?
        var input: AVCaptureDeviceInput!
        //Set capture device to be back camera
        let backCamera = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        
        do{
            //try to access back camera
            input = try AVCaptureDeviceInput(device: backCamera)
            
        }catch let error1 as NSError{
            error = error1
            input = nil
            //print error code
            print(error?.localizedDescription)
            
        }
        //if no error ocurred and there is an input device accesible add inbput to current session
        if error == nil && session!.canAddInput(input) {
            
            session?.addInput(input)
            
            //Set output to be a jpeg
            stillImageOutput = AVCaptureStillImageOutput()
            stillImageOutput?.outputSettings = [AVVideoCodecKey: AVVideoCodecJPEG]
            
            //If session accepts output
            if session!.canAddOutput(stillImageOutput){
                session!.addOutput(stillImageOutput)
                
                //Set up video preview from camera into the view
                videoPreviewLayer = AVCaptureVideoPreviewLayer(session: session)
                videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspect
                
                videoPreviewLayer?.connection.videoOrientation = AVCaptureVideoOrientation.Portrait
                cameraView.layer.addSublayer(videoPreviewLayer!)
                
                //Overlay button to eake picture on top of UIView
                
                cameraView?.layer.addSublayer(cameraButton.layer)
            cameraView.layer.addSublayer(takenPicture.layer)
                
                cameraView.layer.addSublayer(pictureDisplayView.layer)
                

                
                //Initiate session
                session?.startRunning()
                
            }
        }
      }
    
    //Tap action to take a picture
   

        
        
    

    func onPictureTaken() {
        //Get the connection from the stillImageOutput
        if let videoConnection = stillImageOutput?.connectionWithMediaType(AVMediaTypeVideo){
            
            stillImageOutput?.captureStillImageAsynchronouslyFromConnection(videoConnection, completionHandler: { (sampleBuffer, error) -> Void in
                
                
                // process the image data found in sampleBuffer in order to end up with a UIImage
                if sampleBuffer != nil{
                    
                    let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(sampleBuffer)
                    let dataProvider = CGDataProviderCreateWithCFData(imageData)
                    let cgImageRef = CGImageCreateWithJPEGDataProvider(dataProvider, nil, true, CGColorRenderingIntent.RenderingIntentDefault)
                    //Get an UIImage
                     let image = UIImage(CGImage: cgImageRef!,scale: 1.0,orientation: UIImageOrientation.Right)
                    //
                    self.takenPicture.image = image
                    self.takenPicture.hidden = false
                    self.pictureDisplayView.alpha = 0.8
                    self.pictureDisplayView.hidden = false
                    
                    
                        NSLog("GOT IMAGE")
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
