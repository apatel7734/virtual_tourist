//
//  Photo.swift
//  Virtual Tourist
//
//  Created by Ashish Patel on 7/13/15.
//  Copyright (c) 2015 Average Techie. All rights reserved.
//

import Foundation
//step.1 import coredata
import CoreData

//step.2 make Photo available to Objective-C code
@objc(Photo)

//step.3 make subclass of NSManagedObject
class Photo: NSManagedObject {
    
    struct Keys {
        static let Id = "id"
        static let Owner = "owner"
        static let Secret = "secret"
        static let Farm = "farm"
        static let Server = "server"
        static let Title = "title"
        static let IsFriend = "isfriend"
        static let IsPublic = "ispublic"
        static let IsFamily = "isfamily"
    }
    
    //step.4 promot required properties to coredata attributes
    @NSManaged var id: String?
    @NSManaged var owner: String?
    @NSManaged var secret : String?
    @NSManaged var server : String?
    @NSManaged var farm: NSNumber?
    @NSManaged var title : String?
    @NSManaged var isFriend: NSNumber?
    @NSManaged var isPublic: NSNumber?
    @NSManaged var isFamily: NSNumber?
    @NSManaged var pin: Pin?
    
    //step.5 include standard core data init method
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    //    let photo: NSDictionary?
    //
    //    init(photo: NSDictionary?){
    //        self.photo = photo
    //    }
    //
    //    func getId() -> String?{
    //        return photo?.valueForKey("id") as? String
    //    }
    //    func getFarm() -> Int?{
    //        return photo?.valueForKey("farm") as? Int
    //    }
    //    func isFamily() -> Bool?{
    //        return photo?.valueForKey("isfamily") as? Bool
    //    }
    //
    //    func isFriend() -> Bool?{
    //        return photo?.valueForKey("isfriend") as? Bool
    //    }
    //    func isPublic() -> Bool?{
    //        return photo?.valueForKey("ispublic") as? Bool
    //    }
    //    func getOwner() -> String?{
    //        return photo?.valueForKey("owner") as? String
    //    }
    //
    //    func getSecret() -> String?{
    //        return photo?.valueForKey("secret") as? String
    //    }
    //    func getServer() -> String?{
    //        return photo?.valueForKey("server") as? String
    //    }
    //    func getTitle() -> String?{
    //        return photo?.valueForKey("title") as? String
    //    }
    
    //step.6 the two argumens init method
    init(photo: NSDictionary?, latitude: Double, longitude:Double, context: NSManagedObjectContext){
        
        //core data
        let entity = NSEntityDescription.entityForName("Pin", inManagedObjectContext: context)!
        super.init(entity: entity, insertIntoManagedObjectContext: context)
        
        //dictionary
        if let val = photo{
            id = val.valueForKey(Keys.Id) as? String
            owner = val.valueForKey(Keys.Owner) as? String
            secret = val.valueForKey(Keys.Secret) as? String
            farm = val.valueForKey(Keys.Farm) as? Int
            server = val.valueForKey(Keys.Server) as? String
            title = val.valueForKey(Keys.Title) as? String
            isFriend = val.valueForKey(Keys.IsFriend) as? Bool
            isPublic = val.valueForKey(Keys.IsPublic) as? Bool
            isFamily = val.valueForKey(Keys.IsFamily) as? Bool
            pin = Pin(lat: latitude, lng: longitude, context: context)
        }
    }
}