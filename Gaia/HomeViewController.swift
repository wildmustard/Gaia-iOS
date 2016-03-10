//
//  HomeViewController.swift
//  Gaia
//
//  Created by Alex Clark on 3/8/16.
//  Copyright © 2016 John Henning. All rights reserved.
//

import UIKit
import AVFoundation

class HomeViewController: UIViewController {
    
    //Outlet for camera preview
    @IBOutlet weak var cameraView: UIView!
    
    var session: AVCaptureSession?
    var stillImageOutput : AVCaptureStillImageOutput?
    var videoPreviewLayer : AVCaptureVideoPreviewLayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
                
                //Initiate session
                session?.startRunning()
                
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
