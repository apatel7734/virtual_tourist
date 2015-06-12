//
//  FlickerClient.swift
//  Virtual Tourist
//
//  Created by Ashish Patel on 6/1/15.
//  Copyright (c) 2015 Average Techie. All rights reserved.
//

import Foundation
/*
https://api.flickr.com/services/rest/?method=flickr.photos.geo.photosForLocation&api_key=0cff1ea87d47aab1baf2f0214575bb73&lat=37.8064754&lon=-122.2717999&format=json&nojsoncallback=1&auth_token=72157651649499263-2cb4c525582386ec&api_sig=99cdb5c9390968d41d0d2889a8b7c1e9
*/

class FlickerClient: NetworkClient {
    
    func getPhotosForLocation(){
        var url = NSURL(string: Constants.BaseUrl)!
        //step 1. Make Request from URL
        let request = NSMutableURLRequest(URL: url)
        
        //step 2. define values/parameter for request
        request.HTTPMethod = Methods.POST
    }
    
    
    func getRequestToken(){
        var url = NSURL(string: Constants.RequestTokenUrl)!
        
        //step 1. MakeRequest from Url
        let request = NSMutableURLRequest(URL: url)
        //step 2. define parameter values
        request.HTTPMethod = Methods.GET
    }
    
   class func signRequest() ->String{
        //create and return request signature
        //step 1: create auth base string.
        var baseString = getAuthBaseString()
    
    
        return baseString
    }
}

func getAuthBaseString() -> String {
    
    var oAuthNonceVal = 89601180
    var oAuthTimestamp = 1305583298
    var oAuthConsumerKeyVal = ""
    var signatureMethodVal = "HMAC-SHA1"
    
    var params = [
        Parameters.OauthNonce:oAuthNonceVal,
        Parameters.OauthTimestamp:oAuthTimestamp,
        Parameters.OauthConsumerKey:oAuthConsumerKeyVal,
        Parameters.OauthSignatureMethod:signatureMethodVal,
        Parameters.OauthVersion:1.0,
        Parameters.OauthCallback:"www.udacity.com"
    ]
    
    var baseString = "\(Methods.GET)&\(Constants.BaseUrl)?"
    var counter = 0
    for (key, value) in params {
        
        let stringValue = "\(value)"
        
        /* Escape it */
        let escapedValue = stringValue.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
        
        /* FIX: Replace spaces with '+' */
        let replaceSpaceValue = stringValue.stringByReplacingOccurrencesOfString(" ", withString: "+", options: NSStringCompareOptions.LiteralSearch, range: nil)
        
        println("Key = \(key) and Val = \(replaceSpaceValue)")
        
        if(counter == 0){
            baseString = baseString+"\(key)=\(replaceSpaceValue)&"
        }else if (counter == params.count){
            baseString = baseString+"\(key)=\(replaceSpaceValue)"
        }else{
            baseString = baseString+"\(key)=\(replaceSpaceValue)"
        }
        counter++
    }
    return baseString
    
}

struct Constants {
    static let BaseUrl = "https://api.flickr.com/services/rest/"
    static let RequestTokenUrl = "https://www.flickr.com/services/oauth/request_token"
    static let AuthorizaztionUrl = "https://www.flickr.com/services/oauth/authorize"
    static let Json = "json"
}

struct Methods {
    static let PhotosForLocation = "flickr.photos.geo.photosForLocation"
    static let POST = "POST"
    static let GET = "GET"
}

struct Parameters {
    static let apiKeys = "api_key"
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
}