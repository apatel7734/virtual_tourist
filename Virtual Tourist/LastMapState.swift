//
//  LastMapState.swift
//  Virtual Tourist
//
//  Created by Ashish Patel on 5/31/15.
//  Copyright (c) 2015 Average Techie. All rights reserved.
//

import Foundation
import MapKit


class LastMapState {
    
    struct Keys {
        static var CENTER_LAT_KEY = "center_lat_key"
        static var CENTER_LNG_KEY = "center_lng_key"
        static var LATITUDE_DELTA = "lat_delta"
        static var LONGITUDE_DELTA = "lng_delta"
    }
    
    var centerCoord: CLLocationCoordinate2D
    var regionSpan: MKCoordinateSpan
    
    init(coordinate: CLLocationCoordinate2D, span: MKCoordinateSpan) {
        self.centerCoord = coordinate
        self.regionSpan = span
    }
    
    func saveLastMapState(){
        NSUserDefaults.standardUserDefaults().setDouble(centerCoord.latitude, forKey: Keys.CENTER_LAT_KEY)
        NSUserDefaults.standardUserDefaults().setDouble(centerCoord.longitude, forKey: Keys.CENTER_LNG_KEY)
        NSUserDefaults.standardUserDefaults().setDouble(regionSpan.latitudeDelta, forKey: Keys.LATITUDE_DELTA)
        NSUserDefaults.standardUserDefaults().setDouble(regionSpan.longitudeDelta, forKey: Keys.LONGITUDE_DELTA)
    }
    
    class func getLastMapState() -> LastMapState {
        
        var centerLat = NSUserDefaults.standardUserDefaults().doubleForKey(Keys.CENTER_LAT_KEY)
        var centerLng = NSUserDefaults.standardUserDefaults().doubleForKey(Keys.CENTER_LNG_KEY)
        
        var latitudeDelta = NSUserDefaults.standardUserDefaults().doubleForKey(Keys.LATITUDE_DELTA)
        var longitudeDelta = NSUserDefaults.standardUserDefaults().doubleForKey(Keys.LONGITUDE_DELTA)
        
        var centerCoord = CLLocationCoordinate2D(latitude: centerLat, longitude: centerLng)
        var regionSpan = MKCoordinateSpan(latitudeDelta: latitudeDelta, longitudeDelta: longitudeDelta)
        
        return LastMapState(coordinate: centerCoord, span: regionSpan)
    }
    
}