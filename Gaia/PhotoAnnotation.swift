//
//  PhotoAnnotation.swift
//  Gaia
//
//  Created by John Henning on 4/5/16.
//  Copyright © 2016 John Henning. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class PhotoAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2DMake(0, 0)
    internal var photo: UIImage?
    internal var title: String?
}
