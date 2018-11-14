//
//  TweetRepo.swift
//  WhoSaidIt
//
//  Created by Jake Thurman on 11/12/18.
//  Copyright © 2018 TGS. All rights reserved.
//

import Foundation

class TweetRepo {
    // Singleton
    static let instance = TweetRepo(loader: TweetLoader())
    
    let loader: TweetLoader
    var minIdSeen: Int64? = nil
    
    var nextTweetListener: ((TweetData) -> ())? = nil
    
    var tweets: [TweetData] {
        didSet {
            let minTweet = self.tweets.map({ $0.id }).min() ?? Int64.max
            self.minIdSeen = min(self.minIdSeen ?? Int64.max, minTweet)
            
            // If there is callback waiting for tweets call it
            //   and then clear it!
            if let nextTweetListener = self.nextTweetListener {
                if let next = tweets.popLast() {
                    nextTweetListener(next)
                    self.nextTweetListener = nil
                }
            }
        }
    }
    
    private init(loader: TweetLoader) {
        self.loader = loader
        self.tweets = [TweetData]()
        
        // Load some tweets!
        onTweetShortage()
    }
    
    func onTweetShortage() {
        loader.loadNewTweets(
            username: SettingsRepo.instance.twitterOne,
            maxId: minIdSeen,
            onError: { print("error!", $0) },
            onSuccess: { self.addTweets(by: SettingsRepo.instance.twitterOne, rawSet: $0) })
        
        loader.loadNewTweets(
            username: SettingsRepo.instance.twitterTwo,
            maxId: minIdSeen,
            onError: { print("error!", $0) },
            onSuccess: { self.addTweets(by: SettingsRepo.instance.twitterTwo, rawSet: $0) })
    }

    func addTweets(by user: String, rawSet: [[String: Any]]) {
        tweets.append(contentsOf: rawSet.map {
            TweetData(
                user: user,
                id: ($0["id"] as? Int64) ?? Int64.max,
                text: ($0["text"] as? String) ?? ""
            )
        })
        tweets = tweets.shuffled()
    }
    
    func getNext(onWaiting: @escaping () -> (), callback: @escaping (TweetData) -> ()) {
        if tweets.count < 6 {
            onTweetShortage()
        }
        
        if let next = self.tweets.popLast() {
            callback(next)
        }
        else {
            self.nextTweetListener = callback // Call the callback when the next tweet is updated
            onWaiting()
        }
    }
}
