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
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        if gestureRecognizer.state != UIGestureRecognizerState.Began{
            println("HandleLongPressGesture.Not Began")
            return
        }
        println("HandleLongPressGesture.Began")
        var touchPoint: CGPoint = gestureRecognizer.locationInView(self.mapView)
        var touchMapCoord: CLLocationCoordinate2D  = self.mapView.convertPoint(touchPoint, toCoordinateFromView: self.mapView)
        addAnnotation(touchMapCoord)
    }
    
    func addAnnotation(touchCoord: CLLocationCoordinate2D){
       var placeMark = MKPlacemark(coordinate: touchCoord, addressDictionary: nil)
        self.mapView.addAnnotation(placeMark)
    }
    
    
}

