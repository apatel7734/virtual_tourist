//
//  Photo.swift
//  Virtual Tourist
//
//  Created by Ashish Patel on 7/13/15.
//  Copyright (c) 2015 Average Techie. All rights reserved.
//

import Foundation

class Photo {
    
    let photo: NSDictionary?
    
    init(photo: NSDictionary?){
        self.photo = photo
    }
    
    func getId() -> String?{
        return photo?.valueForKey("id") as? String
    }
    func getFarm() -> Int?{
        return photo?.valueForKey("farm") as? Int
    }
    func isFamily() -> Bool?{
        return photo?.valueForKey("isfamily") as? Bool
    }
    
    func isFriend() -> Bool?{
        return photo?.valueForKey("isfriend") as? Bool
    }
    func isPublic() -> Bool?{
        return photo?.valueForKey("ispublic") as? Bool
    }
    func getOwner() -> String?{
        return photo?.valueForKey("owner") as? String
    }
    
    func getSecret() -> String?{
        return photo?.valueForKey("secret") as? String
    }
    func getServer() -> String?{
        return photo?.valueForKey("server") as? String
    }
    func getTitle() -> String?{
        return photo?.valueForKey("title") as? String
    }
    
    
   
    
    
    
    
//    var id: String?
//    var owner: String?
//    var secret : String?
//    var server : String?
//    var farm: Int?
//    var title : String?
//    var isFriend: Bool?
//    var isPublic: Bool?
//    var isFamily: Bool?
//    
//    init(photo: NSDictionary?){
//        if let val = photo{
//            id = val.valueForKey("id") as? String
//            owner = val.valueForKey("owner") as? String
//            secret = val.valueForKey("secret") as? String
//            farm = val.valueForKey("farm") as? Int
//            server = val.valueForKey("server") as? String
//            title = val.valueForKey("title") as? String
//            isFriend = val.valueForKey("isfriend") as? Bool
//            isPublic = val.valueForKey("ispublic") as? Bool
//            isFamily = val.valueForKey("isfamily") as? Bool
//            
//        }
//    }
    
}