//
//  Pin.swift
//  Virtual Tourist
//
//  Created by Ashish Patel on 7/17/15.
//  Copyright (c) 2015 Average Techie. All rights reserved.
//

import Foundation
//step.1 import core data
import CoreData

//step.2 make Pin available to Objective-C
@objc(Pin)

//step.3 subclass of NSManageObject
class Pin: NSManagedObject {

    
    //step.4 make @NSManaged proeprties
    @NSManaged var latitude: NSNumber?
    @NSManaged var longitude: NSNumber?
    @NSManaged var photos: [Photo]
    
    //step.4 default initializer
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    //step.5 two argument initializer
    init(lat: Double,lng: Double, context: NSManagedObjectContext){
        //core data
        let entity = NSEntityDescription.entityForName("Pin", inManagedObjectContext: context)!
        super.init(entity: entity, insertIntoManagedObjectContext: context)

        //get the latitude and longitude
        self.latitude = lat
        self.longitude = lng
    }
}