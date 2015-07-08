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
    
    
    class func getRequestToken(){
        var url = NSURL(string: Constants.RequestTokenUrl)!
        
        //step 1. MakeRequest from Url
        let request = NSMutableURLRequest(URL: url)
        
        //step 2. define parameter values
        request.HTTPMethod = Methods.GET
        var apiSignature = signRequest()
        
        var tokenUrl = getRequestTokenParam(apiSignature)
        println("Token URL = \(tokenUrl)")
    }
    
    class func signRequest() ->String{
        //Create Base Request
        var baseString = getAuthBaseString()
        //Sign Request
        var apiSign = baseString.hmac(CryptoAlgorithm.SHA1, key:Constants.Consumerkey)
        println("apiSign : \(apiSign)")
        return apiSign
    }
    
}

func getAuthBaseString() -> String {
    
    var oAuthNonceVal = 89601180
    var oAuthTimestamp = 1305583298
    var oAuthConsumerKeyVal = Constants.Consumerkey
    var signatureMethodVal = "HMAC-SHA1"
    
    let params = [
        Parameters.OauthNonce:oAuthNonceVal,
        Parameters.OauthTimestamp:oAuthTimestamp,
        Parameters.OauthConsumerKey:oAuthConsumerKeyVal,
        Parameters.OauthSignatureMethod:signatureMethodVal,
        Parameters.OauthVersion:1.0,
        Parameters.OauthCallback:"www.udacity.com"
    ]
    

    
    var paramKeys = Array(params.keyEnumerator())

    sort(&paramKeys)
    
//    println("Param Keys = \(paramKeys)")
    
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


func getRequestTokenParam(apiSignature: String) -> String{
    var oAuthNonceVal = 89601180
    var oAuthTimestamp = 1305583298
    var oAuthConsumerKeyVal = Constants.Consumerkey
    var signatureMethodVal = "HMAC-SHA1"
    var oAuthSignatureVal = apiSignature
    var oAuthCallback = "www.udacity.com"
    
    var paramKeys = [Parameters.OauthNonce,Parameters.OauthTimestamp,Parameters.OauthConsumerKey,Parameters.OauthVersion,Parameters.OauthCallback]
    
    var params = [
        Parameters.OauthNonce:oAuthNonceVal,
        Parameters.OauthTimestamp:oAuthTimestamp,
        Parameters.OauthConsumerKey:oAuthConsumerKeyVal,
        Parameters.OauthSignatureMethod:signatureMethodVal,
        Parameters.OauthVersion:1.0,
        Parameters.OauthCallback:"www.udacity.com"
    ]
    
    let sortedParams = sort(&paramKeys)
    
    var baseString = "\(Constants.RequestTokenUrl)?"
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
    static let Consumerkey = "c6c450a751c5abf924d3eccf67c85b07"
    static let ConsumerSecret = "128d00f8743aad3d"
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