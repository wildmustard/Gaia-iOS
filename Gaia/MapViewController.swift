//
//  MapViewController.swift
//  Gaia
//
//  Created by Carlos Avogadro on 3/13/16.
//  Copyright © 2016 John Henning. All rights reserved.
//

import UIKit
import Parse
import MapKit
import CoreLocation
import SVProgressHUD

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    internal var content: [PFObject]?
    internal var imageCache = [Int:UIImage]()
    
    var locationManager = CLLocationManager()
    var locationArray = [Int]()
    
    var defaults: NSUserDefaults?
    
    @IBOutlet weak var mapView: MKMapView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        defaults = NSUserDefaults.standardUserDefaults()
        
        mapView.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.distanceFilter = 20
        
        
        
        if let launchDate = defaults?.objectForKey("launchDate") as? NSDate {
            let elapsedTime = NSDate().timeIntervalSinceDate(launchDate)
            
            if elapsedTime > 600 {
                defaults?.setBool(false, forKey: "launchedBefore")
            }
        }
        

        
        if let latitude = defaults?.doubleForKey("latitude"), longitude = defaults?.doubleForKey("longitude"), latitudeDelta = defaults?.doubleForKey("latitudeDelta"),longitudeDelta = defaults?.doubleForKey("longitudeDelta") where defaults!.boolForKey("launchedBefore") {
            let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            let span = MKCoordinateSpanMake(latitudeDelta, longitudeDelta)
            let region = MKCoordinateRegionMake(coordinate, span)
            
//            if CLLocationManager.locationServicesEnabled() {
//                locationManager.requestLocation()
//                mapView.showsUserLocation = true
//            }
            
            mapView.setRegion(region, animated: false)
            
        }
//        if let region = defaults?.objectForKey("region") as? MKCoordinateRegion {
//            mapView.setRegion(region, animated: true)
//        }
        else if CLLocationManager.locationServicesEnabled() {
            view.userInteractionEnabled = false;
            SVProgressHUD.show()
            locationManager.requestLocation()
        }
            
        else if content!.count > 0 {
            let count = UInt32(locationArray.count)
            let randomIndex = Int(arc4random_uniform(count))
            
            let location = content![locationArray[randomIndex]]["location"] as? PFGeoPoint
            
            let coordinate = CLLocationCoordinate2D(latitude: (location?.latitude)!, longitude: (location?.longitude)!)
            print(coordinate)
            let span = MKCoordinateSpanMake(0.1, 0.1)
            let region = MKCoordinateRegionMake(coordinate, span)
            mapView.setRegion(region, animated: true)
            
        }
            // if there are no images, and location is disabled, center on San Francisco
        else {
            let coordinate = CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194)
            let span = MKCoordinateSpanMake(0.1, 0.1)
            let region = MKCoordinateRegionMake(coordinate, span)
            mapView.setRegion(region, animated: true)
        }
        
        defaults?.setObject(NSDate() as NSObject, forKey: "launchDate")
        defaults?.setBool(true, forKey: "launchedBefore")
        // Do any additional setup after loading the view.
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        var count = 0
        for each in self.content! {
            
            if let location = each["location"] as? PFGeoPoint {
                if let imageFile = each["image"] as? PFFile {
                    imageFile.getDataInBackgroundWithBlock({ (data: NSData?, error: NSError?) ->
                        Void in
                        
                        // Failure to get image
                        if let error = error {
                            
                            // Log Failure
                            NSLog("Unable to get image data for image \(count)\nError: \(error.localizedDescription)")
                            
                        }
                            // Success getting image
                        else {
                            
                            // Get image and set to cell's content
                            let image = UIImage(data: data!)
                            
                            //let image = UIImage(CGImage: cgImageRef!,scale: 1.0,orientation: UIImageOrientation.Right)
                            let portraitImage = UIImage(CGImage: (image?.CGImage)!,scale: 1.0,orientation: UIImageOrientation.Right)
                            
                            // Set image and tag for cell
                            
                            // Set the cache index
                            self.imageCache[count] = portraitImage
                        }
                    })
                }
                let coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
                let annotation = PhotoAnnotation()
                annotation.coordinate = coordinate
                annotation.photo = self.imageCache[count]
                locationArray.append(count)
                annotation.title = (each["tag"] as? String)!
                mapView.addAnnotation(annotation)
                //print("test")
            }
            count += 1
        }
        
        //print(locationArray)
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.defaults?.setDouble(self.mapView.region.center.latitude, forKey: "latitude")
        self.defaults?.setDouble(self.mapView.region.center.longitude, forKey: "longitude")
        self.defaults?.setDouble(self.mapView.region.span.latitudeDelta, forKey: "latitudeDelta")
        self.defaults?.setDouble(self.mapView.region.span.longitudeDelta, forKey: "longitudeDelta")
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseID = "myAnnotationView"
        
        if annotation.isKindOfClass(MKUserLocation) {
            return nil
        }
        
        var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseID)
        if (annotationView == nil) {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
            annotationView!.canShowCallout = true
            annotationView!.leftCalloutAccessoryView = UIImageView(frame: CGRect(x:0, y:0, width: 50, height:50))
        }
        
       
        
        if let photoAnnotation = annotation as? PhotoAnnotation {
            let imageView = annotationView?.leftCalloutAccessoryView as! UIImageView
            imageView.contentMode = UIViewContentMode.ScaleAspectFill
            imageView.image = photoAnnotation.photo!
        }
        
        
        
        return annotationView
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.AuthorizedWhenInUse {
            
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            view.userInteractionEnabled = true
            SVProgressHUD.dismiss()
            let coordinate = location.coordinate
            let span = MKCoordinateSpanMake(0.1, 0.1)
            let region = MKCoordinateRegionMake(coordinate, span)
            mapView.setRegion(region, animated: true)
            
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print(error.localizedDescription)
        view.userInteractionEnabled = true
        SVProgressHUD.dismiss()
        
        //if location cannot be found, region is set on random capture
        if content!.count > 0 {
            let count = UInt32(locationArray.count)
            let randomIndex = Int(arc4random_uniform(count))
            
            let location = content![locationArray[randomIndex]]["location"] as? PFGeoPoint
            
            let coordinate = CLLocationCoordinate2D(latitude: (location?.latitude)!, longitude: (location?.longitude)!)
            let span = MKCoordinateSpanMake(0.1, 0.1)
            let region = MKCoordinateRegionMake(coordinate, span)
            mapView.setRegion(region, animated: true)
            
        }
        // if there are no images, center on San Francisco
        else {
            let coordinate = CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194)
            let span = MKCoordinateSpanMake(0.1, 0.1)
            let region = MKCoordinateRegionMake(coordinate, span)
            mapView.setRegion(region, animated: true)
        }
    }
    
    func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {
        view.userInteractionEnabled = true
        SVProgressHUD.dismiss()
        mapView.showsUserLocation = true
        let span = MKCoordinateSpanMake(0.1, 0.1)
        let region = MKCoordinateRegionMake(mapView.userLocation.coordinate, span)
        mapView.setRegion(region, animated: true)
    }
    
    //Dismisses current view and returns to homeView, have to fix, should return to catalogue view
    @IBAction func onBack(sender: AnyObject) {

        //self.defaults?.setObject(self.mapView.region as? AnyObject, forKey: "region")
        
        self.dismissViewControllerAnimated(true, completion: {
            
        })
        
    }

}
