//
//  PhotoAlbumViewController.swift
//  Virtual Tourist
//
//  Created by Ashish Patel on 5/31/15.
//  Copyright (c) 2015 Average Techie. All rights reserved.
//

import UIKit
import MapKit

class PhotoAlbumViewController: UIViewController {
    
    var annotation: MKAnnotation?
    
    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        if let pin = annotation{
            println("Pin = \(pin.coordinate.latitude) , \(pin.coordinate.longitude)")
            mapView.addAnnotation(pin)
            mapView.centerCoordinate = pin.coordinate
        }
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
