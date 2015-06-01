//
//  LocationMapViewController.swift
//  Virtual Tourist
//
//  Created by Ashish Patel on 5/10/15.
//  Copyright (c) 2015 Average Techie. All rights reserved.
//

import UIKit
import MapKit

class LocationMapViewController: UIViewController,MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        mapView.showsUserLocation = true
        mapView.delegate = self
        addLongPressGestureToMapView()
        
        //retrieve last saved location if any.
        var lastMapState = LastMapState.getLastMapState()
        println("Map state before = \(lastMapState)")
        if(lastMapState.centerCoord.latitude > 0.0){
            println("Map state = \(lastMapState)")
            var region = MKCoordinateRegionMake(lastMapState.centerCoord, lastMapState.regionSpan)
            mapView.setRegion(region, animated: true)
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        //save state of the map
        var lastMapState = LastMapState(coordinate: mapView.centerCoordinate, span: mapView.region.span)
        lastMapState.saveLastMapState()
    }
    
    var filePath : String {
        let manager = NSFileManager.defaultManager()
        let url = manager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first as! NSURL
        return url.URLByAppendingPathComponent("locationstate").path!
    }
    
    func addLongPressGestureToMapView(){
        var longPressGesture = UILongPressGestureRecognizer(target: self, action: "handleLongPress:")
        longPressGesture.minimumPressDuration = 1.0
        self.mapView.addGestureRecognizer(longPressGesture)
    }
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        var annotationView = MKPinAnnotationView()
        annotationView.animatesDrop = true
        annotationView.setSelected(true, animated: true)
        return annotationView
    }
    
    func handleLongPress(gestureRecognizer: UILongPressGestureRecognizer){
        //check for press up event and return so dont add pin twice
        if gestureRecognizer.state == UIGestureRecognizerState.Ended{
            return
        }
        var touchPoint: CGPoint = gestureRecognizer.locationInView(self.mapView)
        var touchMapCoord: CLLocationCoordinate2D  = self.mapView.convertPoint(touchPoint, toCoordinateFromView: self.mapView)
        addAnnotation(touchMapCoord)
    }
    
    //add the new annotation on map to proviced coordinates
    func addAnnotation(touchCoord: CLLocationCoordinate2D){
        var placeMark = MKPlacemark(coordinate: touchCoord, addressDictionary: nil)
        self.mapView.addAnnotation(placeMark)
    }
    
}

