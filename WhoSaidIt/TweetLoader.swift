//
//  TweetLoader.swift
//  WhoSaidIt
//
//  Created by Jake Thurman on 11/13/18.
//  Copyright © 2018 TGS. All rights reserved.
//

import Foundation

class TweetLoader : NSObject, URLSessionDelegate {
    let session: URLSession
    var requestsInProgress = [String]()
    
    override init() {
        session = URLSession(configuration: .default, delegate: nil, delegateQueue: nil)
        super.init()
    }
    
    func loadNewTweets(username: String, maxId: Int?, onError: @escaping (Any) -> Void, onSuccess: @escaping (Any) -> Void) {
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
        var urlString = "https://api.twitter.com/1.1/statuses/user_timeline.json?exclude_replies=1&include_rts=0&trim_user=1&screen_name=\(username)"
        
        // Append the maxId if we have it
        if let maxId = maxId {
            urlString += "&max_id=\(maxId)"
        }
        
        // Stick the url in a url object and ensure we really have it
        guard let url = URL(string: urlString) else {
            onError("Failed to make url for twitter data: \(urlString)")
            return
        }
        
        // Setup a download task to load the url
        let task = session.downloadTask(with: url) { (downloadedTo, _, __) in
            
            // make sure the url was actually downloaded!
            guard let downloadedTo = downloadedTo else {
                onError("A download error occured :(")
                return
            }
            
            do {
                // Parse out the content of the
                let content = try Data(contentsOf: downloadedTo)
                let obj = try JSONSerialization.jsonObject(with: content, options: .mutableContainers)
                guard let dict = obj as? [String : AnyObject] else {
                    onError(obj)
                    return
                }
                
                if let errors = dict["errors"] {
                    onError(errors)
                }
                else {
                    // Guess what? No errors!
                    onSuccess(dict)
                    cleanup() // error never got called, still perform cleanup
                }
            }
            catch {
                onError("An exception was thrown trying to extract data from api request")
            }
        }
        
        // Start the download task
        task.resume()
    }
}
