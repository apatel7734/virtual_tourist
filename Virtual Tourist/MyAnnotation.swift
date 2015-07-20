//
//  MyAnnotation.swift
//  Virtual Tourist
//
//  Created by Ashish Patel on 7/20/15.
//  Copyright (c) 2015 Average Techie. All rights reserved.
//

import UIKit
import MapKit

class MyAnnotation: NSObject, MKAnnotation {
    
    var pin: Pin?
    
    init(pin: Pin){
        self.pin = pin
        super.init()
    }
    
    var coordinate: CLLocationCoordinate2D {
        var lat = pin?.latitude as! Double
        var lng = pin?.longitude as! Double
        
        return CLLocationCoordinate2D(latitude: lat, longitude: lng)
    }
}
