//
//  LocationMapViewController.swift
//  Virtual Tourist
//
//  Created by Ashish Patel on 5/10/15.
//  Copyright (c) 2015 Average Techie. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class LocationMapViewController: UIViewController,MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    //    var pins = [AnyObject]()
    var pins: [Pin] = [Pin]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        mapView.showsUserLocation = true
        mapView.delegate = self
        addLongPressGestureToMapView()
        
        //retrieve last saved location if any.
        var lastMapState = LastMapState.getLastMapState()
        if(lastMapState.centerCoord.latitude > 0.0){
            var region = MKCoordinateRegionMake(lastMapState.centerCoord, lastMapState.regionSpan)
            mapView.setRegion(region, animated: true)
        }
        //retrieve last saved pins if exist
        pins = fetchAllPins()
        
        for pin in pins{
            //            var lat = pin.latitude as! Double
            //            var lng = pin.longitude as! Double
            //            var coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lng)
            //            var placeMark = MKPlacemark(coordinate: coordinate, addressDictionary: nil)
            //            addAnnotationPlacemark(pinPlaceMark)
            addMyAnnotation(pin)
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        //save state of the map
        var lastMapState = LastMapState(coordinate: mapView.centerCoordinate, span: mapView.region.span)
        lastMapState.saveLastMapState()
    }
    
    var locationStateFilePath : String {
        let manager = NSFileManager.defaultManager()
        let url = manager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first as! NSURL
        return url.URLByAppendingPathComponent("locationstate").path!
    }
    
    var pinsFilePath: String{
        let manager = NSFileManager.defaultManager()
        let url = manager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first as!NSURL
        return url.URLByAppendingPathComponent("locationpins").path!
    }
    
    //shared context for core data
    var sharedConext : NSManagedObjectContext{
        return CoreDataStackManager.sharedInstance().managedObjectContext!
    }
    
    //core data fetch pins
    func fetchAllPins() -> [Pin] {
        let error: NSErrorPointer = nil
        
        // Create the Fetch Request
        let fetchRequest = NSFetchRequest(entityName: "Pin")
        
        // Execute the Fetch Request
        var results = sharedConext.executeFetchRequest(fetchRequest, error: error)
        
        // Check for Errors
        if error != nil {
            println("Error in fectchAllActors(): \(error)")
        }
        
        // Return the results, cast to an array of Person objects
        return results as! [Pin]
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
    //save pin to .Documents file directory
    func addNewPin(pin: Pin){
        self.pins.append(pin)
        //save the data
        CoreDataStackManager.sharedInstance().saveContext()
    }
    
    func handleLongPress(gestureRecognizer: UILongPressGestureRecognizer){
        //check for press up event and return so dont add pin twice at same location
        if gestureRecognizer.state == UIGestureRecognizerState.Ended{
            return
        }
        var touchPoint: CGPoint = gestureRecognizer.locationInView(self.mapView)
        var touchMapCoord: CLLocationCoordinate2D  = self.mapView.convertPoint(touchPoint, toCoordinateFromView: self.mapView)
        addAnnotation(touchMapCoord)
    }
    
    //add the new annotation on map to proviced coordinates
    func addAnnotation(touchCoord: CLLocationCoordinate2D){
        let pin = Pin(lat: touchCoord.latitude, lng: touchCoord.longitude, context: sharedConext)
        var annotation = MyAnnotation(pin: pin)
        self.mapView.addAnnotation(annotation)
        //save pin
        addNewPin(pin)
    }

    
    func addMyAnnotation(pin: Pin){
        var annotation = MyAnnotation(pin: pin)
        self.mapView.addAnnotation(annotation)
    }
    
    func mapView(mapView: MKMapView!, didSelectAnnotationView view: MKAnnotationView!) {
        
        mapView.deselectAnnotation(view.annotation, animated: false)
        var photoAlbumVC = self.storyboard?.instantiateViewControllerWithIdentifier("photoalbumvc") as! PhotoAlbumViewController
        photoAlbumVC.annotation = view.annotation
        self.navigationController?.pushViewController(photoAlbumVC, animated: true)
    }
    
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
}

