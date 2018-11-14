//
//  TweetLoader.swift
//  WhoSaidIt
//
//  Created by Jake Thurman on 11/13/18.
//  Copyright © 2018 TGS. All rights reserved.
//

import Foundation
import TwitterKit

class TweetLoader : NSObject, URLSessionDelegate {
    let client: TWTRAPIClient
    var requestsInProgress: [String]
    
    override init() {
        client = TWTRAPIClient()
        
        requestsInProgress = [String]()
        
        //session = URLSession(configuration: .default, delegate: nil, delegateQueue: nil)
        
        super.init()
    }
    
    func loadNewTweets(username: String, maxId: Int64?, onError: @escaping (Any) -> Void, onSuccess: @escaping ([[String: Any]]) -> Void) {
        // Clanup the username given
        let username = username.replacingOccurrences(of: "@", with: "")
        
        // Ignore duplicate requests for the same user
        if requestsInProgress.contains(username) {
            return
        }
        requestsInProgress.append(username)
        
        let cleanup = {
            self.requestsInProgress = self.requestsInProgress.filter(){$0 != username}
        }
        
        let onError: (Any) -> Void = { msg in
            onError(msg)
            cleanup()
        }
        
        // Grab the basic url we want to load
        let urlString = "https://api.twitter.com/1.1/statuses/user_timeline.json"
        
        var params = [
            "exclude_replies": "1",
            "include_rts": "0",
            "trim_user": "1",
            "screen_name": username
        ]
        
        if let maxId = maxId {
            params["max_id"] = "\(maxId)"
        }
        
        var clientError : NSError?
        
        let request = client.urlRequest(withMethod: "GET", urlString: urlString, parameters: params, error: &clientError)
        
        client.sendTwitterRequest(request) { (response, data, connectionError) -> Void in
            if let connectionError = connectionError {
                onError("Error: \(connectionError)")
                return
            }
            
            do {
                let obj = try JSONSerialization.jsonObject(with: data!, options: [])
                if let errors = (obj as? [String: Any])?["errors"] {
                    onError(errors)
                    return
                }
                
                guard let dict = obj as? [[String: Any]] else {
                    onError(obj)
                    return
                }

                // Guess what? No errors!
                onSuccess(dict)
                cleanup() // error never got called, still perform cleanup
            } catch let jsonError as NSError {
                onError(jsonError.localizedDescription)
            }
        }
    }
}
