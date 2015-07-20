//
//  ImageCache.swift
//  Virtual Tourist
//
//  Created by Ashish Patel on 7/15/15.
//  Copyright (c) 2015 Average Techie. All rights reserved.
//

import UIKit

/**
ImageCache Util to store and retrieve image to and from memory and documents directory.
*/

class ImageCache {
    
    private var inMemoryCache = NSCache()
    
    func retrieveImagewithIdentifier(identifier: String?) -> UIImage?{
        //if identifier is empty/nil return true
        if identifier == nil || identifier == "" {
            return nil
        }
        
        let path = pathForIdentifier(identifier!)
        var data: NSData?
        
        //first try to retrieve from memory
        if let image = inMemoryCache.objectForKey(path) as? UIImage{
            return image
        }
        
        //then try to fetch from documents directory
        if let data = NSData(contentsOfFile: path){
            return UIImage(data: data)
        }
        
        return nil
    }
    
    //store image in the memory and file
    func storeImage(image: UIImage? , withIdentifier identifier:String){
        let path = pathForIdentifier(identifier)

        if image == nil{
            inMemoryCache.removeObjectForKey(path)
            NSFileManager.defaultManager().removeItemAtPath(path, error: nil)
            return
        }
        
        // Otherwise, keep the image in memory
        inMemoryCache.setObject(image!, forKey: path)
        
        //And in documents directory
        let data = UIImagePNGRepresentation(image!)
        data.writeToFile(path, atomically: true)
    }
    
    //return the documents directory path from string path
    func pathForIdentifier(identifier: String) -> String {
        let documentsDirectoryURL: NSURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first as! NSURL
        let fullURL = documentsDirectoryURL.URLByAppendingPathComponent(identifier)
        
        return fullURL.path!
    }
    
}