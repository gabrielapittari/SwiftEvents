//
//  APIManager.swift
//  testSwiftEvents
//
//  Created by Gabriela Pittari on 19/07/2016.
//  Copyright © 2016 Gabriela Pittari. All rights reserved.
//

import UIKit

class APIManager: NSObject {
    
    let scheme: String = "https"
    let baseUrl: String = "www.eventbriteapi.com"
    let eventBaseUrl: String = "/v3/events/search/"
    let tokenKey: String = "token"
    let cityKey: String = "venue.city"
    let pageKey: String = "page"
    let token: String = "UPCEJY23QCH25H7NPDY3"
    
    
    func createURLWithComponents(city: String, page: String) -> NSURL? {
        let urlComponents = NSURLComponents()
        urlComponents.scheme = scheme;
        urlComponents.host = baseUrl;
        urlComponents.path = eventBaseUrl;
        
        let tokenQuery = NSURLQueryItem(name: tokenKey, value: token)
        let cityQuery = NSURLQueryItem(name: cityKey, value: city)
        let pageQuery = NSURLQueryItem(name: pageKey, value: page)
        
        urlComponents.queryItems = [tokenQuery, cityQuery, pageQuery]
        
        return urlComponents.URL
    }
    
    func getEvents(city: String, page: String, success: (response: [String: AnyObject]!) -> Void, failure: (error: NSError?) -> Void) {
        let url = createURLWithComponents(city, page: page)
        let request = NSURLRequest(URL: url!)
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: config)
        let task = session.dataTaskWithRequest(request, completionHandler: { (data: NSData?, response: NSURLResponse?, error: NSError?) in
            if error != nil {
                failure(error: error)
            } else {
                var errorCode = 400
                if let httpResponse = response as? NSHTTPURLResponse {
                    errorCode = httpResponse.statusCode
                }
                if errorCode == 200 {
                    do {
                        let jsonArray = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) as? [String: AnyObject]
                        success(response: jsonArray)
                    } catch {
                        print(error)
                        failure(error: NSError(domain: "Error parsing JSON", code: 400, userInfo: nil))
                    }
                } else {
                    failure(error: NSError(domain: "Invalid response", code: errorCode, userInfo: nil))
                }
            }
        });
        
        task.resume()
    }
    
}
