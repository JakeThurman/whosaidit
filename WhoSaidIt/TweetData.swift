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
        self.text = TweetData.removeUrls(text)
        self.user = user
    }
    
    private static func removeUrls(_ string: String) -> String {
        let output = NSMutableString(string: string)
        
        if let regex = try? NSRegularExpression(pattern: "((http)s?://)?[A-Za-z0-9]*\\.[A-Za-z0-9]*(\\.[A-Za-z0-9]*)*[/A-Za-z0-9]*", options: .caseInsensitive)
        {
            regex.replaceMatches(in: output, options: [], range: NSRange(location: 0, length: string.count), withTemplate: "")
        }
        
        return (output as String)
    }
}
