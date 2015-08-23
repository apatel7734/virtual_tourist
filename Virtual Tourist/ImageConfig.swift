//
//  ImageConfig.swift
//  Virtual Tourist
//
//  Created by Ashish Patel on 7/15/15.
//  Copyright (c) 2015 Average Techie. All rights reserved.
//

import Foundation
import UIKit
class ImageConfig {
    
    
    //Shared Instance
    class func sharedInstance() -> ImageConfig{
        struct Singleton{
            static var sharedInstance = ImageConfig()
        }
        return Singleton.sharedInstance
    }
    
    //getPhotoUrl
    func getPhotoUrl(photo: Photo?) -> String?{
        let farmId = photo?.farm
        let server = photo?.server
        let id = photo?.id
        let secret = photo?.secret
        if(farmId !=  nil && server != nil && id != nil && secret != nil){
            var urlStr = "https://farm\(farmId!).staticflickr.com/\(server!)/\(id!)_\(secret!).jpg"
            return urlStr
        }
        return nil
    }
    
    //getPhotoUrl
    func getPhotoPath(photo: Photo?) -> String?{
        let farmId = photo?.farm
        let server = photo?.server
        let id = photo?.id
        let secret = photo?.secret
        if (secret != nil){
            return secret
        }
        return nil
    }
    
    func taskForImageWith(photo: Photo?, completionHandler: (imageData: NSData?, error: NSError?) ->  Void) -> NSURLSessionTask {
        
        var photoUrl = getPhotoUrl(photo)
        
        var url: NSURL?
        if let filePath = photoUrl{
            url = NSURL(string: filePath)
        }
        let request = NSURLRequest(URL: url!)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) {data, response, downloadError in
            if let error = downloadError {
                completionHandler(imageData: nil, error: error)
            } else {
                completionHandler(imageData: data, error: nil)
            }
        }
        task.resume()
        
        return task
    }
    
    
    struct Caches {
        static let imageCache = ImageCache()
    }
    
    /*
    func loadImage(imageView: UIImageView, progressView: UIView, photo: Photo){
        if(photo.photoImage != nil){
            println("Cached Image found....")
            dispatch_async(dispatch_get_main_queue()) {
                imageView.image = photo.photoImage
                progressView.hidden = true
            }
        }else{
            println("Cached Image Not found....")
            var photoUrl = ImageConfig.sharedInstance().getPhotoUrl(photo)
            if let photoUrl = photoUrl{
                var photoNSURL: NSURL = NSURL(string: photoUrl)!
                let request: NSURLRequest = NSURLRequest(URL: photoNSURL)
                NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(),completionHandler: {(response: NSURLResponse!,data: NSData!,error: NSError!) -> Void in
                    
                    if error == nil {
                        var photoImage = UIImage(data: data);
                        //cache image.
                        photo.photoImage = photoImage
                        dispatch_async(dispatch_get_main_queue()) {
                            imageView.image = photoImage
                            progressView.hidden = true
                        }
                    }
                })
            }
        }
    }
    */
}