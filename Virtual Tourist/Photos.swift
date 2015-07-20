//
//  Photos.swift
//  Virtual Tourist
//
//  Created by Ashish Patel on 7/13/15.
//  Copyright (c) 2015 Average Techie. All rights reserved.
//

import Foundation

class Photos{
    //e.g ok
    var stat: String?
    var page: Int?
    var total: Int?
    var pages: Int?
    var perPage: Int?
    var photos = [Photo]()
    
    init(jsonDict: NSDictionary?){
        parseDcitionary(jsonDict)
    }
    
    func parseDcitionary(dict: NSDictionary?){
        if let result = dict {
             stat = result.valueForKey("stat") as? String
            let photos = result.valueForKey("photos") as? NSDictionary
            if let val = photos{
                page = val.valueForKey("page") as? Int
                total = val.valueForKey("total") as? Int
                pages = val.valueForKey("pages") as? Int
                perPage = val.valueForKey("perpage") as? Int
                let photoList = val.valueForKey("photo") as? NSArray
                if let array = photoList{
                    for photo in array{
                        //TODO: create photo here
//                        self.photos.append(Photo(photo: photo as? NSDictionary))
                    }
                }
            }
        }else{
            println("Empty dictionary")
        }
    }
}
