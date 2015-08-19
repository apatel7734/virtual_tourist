//
//  FlickerClient.swift
//  Virtual Tourist
//
//  Created by Ashish Patel on 6/1/15.
//  Copyright (c) 2015 Average Techie. All rights reserved.
//

import Foundation

class FlickerClient: NetworkClient {
    
    func getPhotosForLocation(lat: String, lng: String, pageNum: Int,completionHandler: (returnedPhotos: Photos?,error: NSError?) -> Void){
        
        println("fetchFlickrImages.. pageNum = \(pageNum)")
        let parameters : [String: String] = [
            Parameters.method : Methods.SearchPhotos,
            Parameters.apiKey:Constants.Consumerkey,
            Parameters.lat: lat,
            Parameters.lon : lng,
            Parameters.format : Constants.Json,
            Parameters.NoJsonCallback : "1",
            Parameters.perPage : "30",
            Parameters.page: "\(pageNum)"
        ]
        
        var url = NSURL(string: Constants.BaseUrl + escapedParameters(parameters))!
        println("fetchFlickrImages.. url = \(url)")
        //step 1. Make Request from URL
        let request = NSMutableURLRequest(URL: url)
        
        //step 2. define values/parameter for request
        request.HTTPMethod = Methods.GET
        request.addValue(Parameters.ApplicationJson, forHTTPHeaderField: Parameters.Accept)
        request.addValue(Parameters.ApplicationJson, forHTTPHeaderField: Parameters.ContentType)
        
        //step 3. Session
        let session = NSURLSession.sharedSession()
        
        //step 4. Create task for request
        let task = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
            
            if(error != nil){
                //step 6. handle error.
                //send error creating dataTask
                completionHandler(returnedPhotos: nil, error: error)
            }else{
                //step 7. we got response parse it.
                self.parseJson(data, completionHandler: { (result, error) -> Void in
                    if(error != nil){
                        //send parsing error.
                        completionHandler(returnedPhotos: nil, error: error)
                    }else{
                        //send parsed result with photos
                        let dictResult = result as? NSDictionary
                        let photos = Photos(jsonDict: dictResult)
                        completionHandler(returnedPhotos: photos, error: nil)
                    }
                })
                
            }
            
        })
        //step 5. resume task.
        task.resume()
        
    }
    
    class func sharedInstance() -> FlickerClient{
        struct Singleton {
            static let instance = FlickerClient()
        }
        return Singleton.instance
    }
    
}
struct Constants {
    static let BaseUrl = "https://api.flickr.com/services/rest/"
    static let RequestTokenUrl = "https://www.flickr.com/services/oauth/request_token"
    static let AuthorizaztionUrl = "https://www.flickr.com/services/oauth/authorize"
    static let Json = "json"
    static let Consumerkey = "c6c450a751c5abf924d3eccf67c85b07"
    static let ConsumerSecret = "128d00f8743aad3d"
}

struct Methods {
    static let PhotosForLocation = "flickr.photos.geo.photosForLocation"
    static let  SearchPhotos = "flickr.photos.search"
    static let POST = "POST"
    static let GET = "GET"
}

struct Parameters {
    static let apiKey = "api_key"
    static let method = "method"
    static let OauthNonce = "oauth_nonce"
    static let OauthTimestamp = "oauth_timestamp"
    static let OauthConsumerKey = "oauth_consumer_key"
    static let OauthSignatureMethod = "oauth_signature_method"
    static let OauthVersion = "oauth_version"
    static let OauthSignature = "oauth_signature"
    static let OauthCallback = "oauth_callback"
    static let OauthToken = "oauth_token"
    static let OauthTokenSecret = "oauth_token_secret"
    static let lat = "lat"
    static let lon = "lon"
    static let format = "format"
    static let authToken = "auth_token"
    static let ApplicationJson = "application/json"
    static let ContentType = "Content-Type"
    static let Accept = "Accept"
    static let NoJsonCallback = "nojsoncallback"
    static let perPage = "per_page"
    static let page = "page"
}