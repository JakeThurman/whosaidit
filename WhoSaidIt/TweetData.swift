//
//  TweetData.swift
//  WhoSaidIt
//
//  Created by Jake Thurman on 11/12/18.
//  Copyright © 2018 TGS. All rights reserved.
//

import Foundation

class TweetData {
    let text: String
    let user: String
    
    init(user: String, text: String) {
        // Store the text with urls removed
        let containsUrlRegex = "/(https?:////)?[A-Za-z]+.[A-Za-z]+(.[A-Za-z]+)?/[A-Za-z//]*/g";
        self.text = text.replacingOccurrences(of: containsUrlRegex, with: "")
        
        self.user = user
    }
}
