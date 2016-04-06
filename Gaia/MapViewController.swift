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
        
        if let launchDate = defaults?.objectForKey("launchDate") as? NSDate {
            let elapsedTime = NSDate().timeIntervalSinceDate(launchDate)
            
            if elapsedTime > 600 {
                defaults?.setBool(false, forKey: "launchedBefore")
            }
        }
        
        
        if !defaults!.boolForKey("launchedBefore") {
            defaults?.setObject(NSDate() as NSObject, forKey: "launchDate")
        }
        
        if let latitude = defaults?.doubleForKey("latitude"), longitude = defaults?.doubleForKey("longitude"), latitudeDelta = defaults?.doubleForKey("latitudeDelta"),longitudeDelta = defaults?.doubleForKey("longitudeDelta") where defaults!.boolForKey("launchedBefore") {
            let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            let span = MKCoordinateSpanMake(latitudeDelta, longitudeDelta)
            let region = MKCoordinateRegionMake(coordinate, span)
            mapView.setRegion(region, animated: false)
        }
//        if let region = defaults?.objectForKey("region") as? MKCoordinateRegion {
//            mapView.setRegion(region, animated: true)
//        }
        else if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.distanceFilter = 20
            locationManager.requestLocation()
            
            mapView.userInteractionEnabled = false
            SVProgressHUD.show()

        }
            
        else if content!.count > 0 {
            let count = UInt32(locationArray.count)
            let randomIndex = Int(arc4random_uniform(count))
            
            let location = content![locationArray[randomIndex]]["location"] as? PFGeoPoint
            
            let coordinate = CLLocationCoordinate2D(latitude: (location?.latitude)!, longitude: (location?.longitude)!)
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
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseID = "myAnnotationView"
        
        var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseID)
        if (annotationView == nil) {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
            annotationView!.canShowCallout = true
            annotationView!.leftCalloutAccessoryView = UIImageView(frame: CGRect(x:0, y:0, width: 50, height:50))
        }
        
        let imageView = annotationView?.leftCalloutAccessoryView as! UIImageView
        imageView.contentMode = UIViewContentMode.ScaleAspectFill
        let photoAnnotation = (annotation as? PhotoAnnotation)!
        imageView.image = photoAnnotation.photo!
        
        return annotationView
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.AuthorizedWhenInUse {
            
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            mapView.userInteractionEnabled = true
            SVProgressHUD.dismiss()
            let coordinate = location.coordinate
            let span = MKCoordinateSpanMake(0.1, 0.1)
            let region = MKCoordinateRegionMake(coordinate, span)
            mapView.setRegion(region, animated: true)
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print(error.localizedDescription)
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
        SVProgressHUD.dismiss()
        mapView.showsUserLocation = true
        let span = MKCoordinateSpanMake(0.1, 0.1)
        let region = MKCoordinateRegionMake(mapView.userLocation.coordinate, span)
        mapView.setRegion(region, animated: true)
    }
    
    //Dismisses current view and returns to homeView, have to fix, should return to catalogue view
    @IBAction func onBack(sender: AnyObject) {
        self.defaults?.setDouble(self.mapView.region.center.latitude, forKey: "latitude")
        self.defaults?.setDouble(self.mapView.region.center.longitude, forKey: "longitude")
        self.defaults?.setDouble(self.mapView.region.span.latitudeDelta, forKey: "latitudeDelta")
        self.defaults?.setDouble(self.mapView.region.span.longitudeDelta, forKey: "longitudeDelta")
        //self.defaults?.setObject(self.mapView.region as? AnyObject, forKey: "region")
        
        self.dismissViewControllerAnimated(true, completion: {
            
        })
        
    }

}
