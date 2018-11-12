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
    static let instance = TweetRepo()
    
    // Map from twitter handle to
    var tweets: [TweetData]
    
    private init() {
        tweets = [TweetData]()
        
        // TODO: Load temp sample data
        let user1 = SettingsRepo.instance.twitterOne
        let user2 = SettingsRepo.instance.twitterTwo
        
        tweets = [
        // the onion
            TweetData(user: user2, text: "Trump Hacks Through Thick Central American Jungle In Search Of Entirely New Ethnic Group To Demonize trib.al/vUPcMfY "),
            TweetData(user: user2, text: "Unattractive Man Not Fooling Anyone By Dressing Well trib.al/vUPcMfY "),
            TweetData(user: user2, text: "Report Finds Children Of Parents Often Become Parents Themselves trib.al/vUPcMfY"),
            TweetData(user: user2, text: "Ruth Bader Ginsburg Debating Whether To Cancel Winter Vacation Climbing K2 trib.al/vUPcMfY "),
            
        // cnn
            TweetData(user: user1, text: "A Republican unseated in the midterm elections last week has come out with an op-ed blaming the late Arizona GOP Sen. John McCain for the party losing control of the House https://cnn.it/2DE5fSi"),
            TweetData(user: user1, text: "Lawsuits, PR fights and Florida's ballots: What you should know about the vote recount and what could go wrong in the push to recount ballots quickly https://cnn.it/2QyBdlL "),
            TweetData(user: user1, text: "The Vatican has told the US Conference of Catholic Bishops to delay voting on measures to hold bishops accountable for failing to protect children from sexual abuse https://cnn.it/2QDzCv4")
        ]
        
        tweets = tweets.shuffled()
    }
    
    func getNext() -> TweetData? {
        return tweets.popLast()
    }
}
